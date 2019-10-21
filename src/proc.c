#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "pstat.h"


#define NULL 0

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

// **********************CREATED BY US ***********************
// CREATE AN ARRAY WITH FOUR PRIORITY QUEUES
struct queue {
    struct proc *head;
    struct proc *tail;
};

struct queue priorityQueue[4];

struct pstat fpstat;

int timeslices[4] = {20, 16, 12, 8};


// ***********************************************************

static struct proc *initproc;

void printQueue();

void deleteFromQueue(struct proc *p, int priority){
  
  struct proc *prevProc = NULL;
  struct proc *p_curr;
  
  for(p_curr = priorityQueue[priority].head; p_curr != NULL;) {
    if (p->pid == p_curr->pid){
      if (priorityQueue[priority].head == NULL && priorityQueue[priority].tail == NULL) {
        //cprintf("%s\n", "modified 1");
        
      } else if (priorityQueue[priority].head == priorityQueue[priority].tail){
        //cprintf("%s\n", "modified 2");
        priorityQueue[priority].head = NULL;
        priorityQueue[priority].tail = NULL;
        p_curr->next = NULL;
      }else if (p_curr == priorityQueue[priority].head) {
        //cprintf("%s\n", "modified 3");
        priorityQueue[priority].head = p_curr->next;
        p_curr->next = NULL;
        
      } else if (p_curr == priorityQueue[priority].tail){
        //cprintf("%s\n", "modified 4");
        prevProc->next = NULL;
        priorityQueue[priority].tail = prevProc;
        p_curr->next = NULL;
        
      } else {
        // in the middle
        //cprintf("%s\n", "modified 5");
        prevProc->next = p_curr->next;
        p_curr->next = NULL;
        
      }
      break;
    }
    prevProc = p_curr;
    p_curr = p_curr->next;
  }
}

void enqueueProc(struct proc *p, int priority){
  // 3 cases: head == tail -> empty or 1, 
  //cprintf("%s\n", "enqueuing");
  if (priorityQueue[priority].head == NULL && priorityQueue[priority].tail == NULL) {
    // empty queue
    //cprintf("%s\n", "enqueuing2");
    priorityQueue[priority].head = p;
    priorityQueue[priority].tail = p;
    p->next = NULL;
    //printQueue();
  } else {
    // other case where queue is populated, just send to back
    //cprintf("%s\n", "enqueuing to non empty");
    priorityQueue[priority].tail->next = p;
    priorityQueue[priority].tail = p;
    p->next = NULL;
    //printQueue();
  } 
  //p->qtail[p->priority]++;
  //p->ticks = 0;
  //cprintf("%s\n", "PRINTING NEW Q");
  //printQueue();
}





int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{

    struct proc *p;
    char *sp;


    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if (p->state == UNUSED)
            goto found;


    release(&ptable.lock);
    return 0;

    found:
        p->state = EMBRYO;
        p->pid = nextpid++;

        for (int i = 0; i < 4; i++){
          p->agg_ticks[i] = 0;
          p->qtail[i] = 0;
        }
        
        p->ticks = 0;

        release(&ptable.lock);

        // Allocate kernel stack.
        if ((p->kstack = kalloc()) == 0) {
            p->state = UNUSED;
            return 0;
        }
        sp = p->kstack + KSTACKSIZE;

        // Leave room for trap frame.
        sp -= sizeof *p->tf;
        p->tf = (struct trapframe *) sp;

        // Set up new context to start executing at forkret,
        // which returns to trapret.
        sp -= 4;
        *(uint *) sp = (uint) trapret;

        sp -= sizeof *p->context;
        p->context = (struct context *) sp;
        memset(p->context, 0, sizeof *p->context);
        p->context->eip = (uint) forkret;


  return p;
}

// Set up first user process.
void
userinit(void)
{
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();

    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
    memset(p->tf, 0, sizeof(*p->tf));
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
    p->tf->es = p->tf->ds;
    p->tf->ss = p->tf->ds;
    p->tf->eflags = FL_IF;
    p->tf->esp = PGSIZE;
    p->tf->eip = 0;  // beginning of initcode.S

    safestrcpy(p->name, "initcode", sizeof(p->name));
    p->cwd = namei("/");

    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);

    p->state = RUNNABLE;
    // ADDED BY US

    p->priority = 3;

    if (priorityQueue[p->priority].head == NULL && priorityQueue[p->priority].tail == NULL) {
        p->ticks = 0;
        
        for (int i = 0; i < 4; i++){
          p->agg_ticks[i] = 0;
          p->qtail[i] = 0;
        }
        
        
        priorityQueue[p->priority].head = p;
        priorityQueue[p->priority].tail = p;
    }
    p->next = NULL;

    release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int pid = fork2(3);
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
    struct proc *p;
    struct proc *last = NULL;
    struct cpu *c = mycpu();
    c->proc = 0;

    for (;;) {
        // Enable interrupts on this processor.
        sti();
        // Loop over process table looking for process to run.
        acquire(&ptable.lock);


        int i = 0;

        for (i = 3; i >= 0; i--) {
            struct proc *prevProc = NULL;
            for (p = priorityQueue[i].head; p != NULL;) {
                int priority = p->priority;
                if (p->state == RUNNABLE) {
                    c->proc = p;
                    switchuvm(p);
                    p->state = RUNNING;
                    swtch(&(c->scheduler), p->context);
                    switchkvm();
                    c->proc = 0;

                    if (p->state != RUNNABLE){  
                      //cprintf("%d %d\n", p->pid, p->ticks);
                      if (p->ticks >= timeslices[priority]){
                        p->agg_ticks[priority] += timeslices[priority];
                        p->ticks = 0;
                        last = NULL;
                        break;  
                      }
                      p->ticks++;
                      last = p;
                    }

                    if (last != NULL && last->pid != p->pid){
                        last->ticks = 0; // this is the pre-empted child
                    } 
                    
                    last = p;
                    p->ticks++;
                    // cprintf("PID: %d CURR_TICKS %d AGG_TICKS: %d PRIORITY %d\n", p->pid,p->ticks, p->agg_ticks[priority], priority);
                    if (p->ticks == timeslices[priority]) {
                        // HANDLE CASES WITH THE HEAD FIRST
                        
                        if (priorityQueue[i].head == priorityQueue[i].tail) {
                            // IF HEAD EQUALS TAIL, THEN WE ONLY HAVE ONE ITEM IN QUEUE
                            p->agg_ticks[priority] += timeslices[priority];
                            p->qtail[priority]++;
                            p->ticks = 0;
                            last = NULL;
                            break;
                        } else if (priorityQueue[i].head == p) {
                            // SET HEAD TO NEXT PROC
                            priorityQueue[i].head = p->next;
                            p->agg_ticks[priority] += timeslices[priority];
                        } else {
                            p->agg_ticks[priority] += timeslices[priority];
                            if (priorityQueue[priority].tail == p) {
                                p->qtail[priority]++;
                                p->ticks = 0;
                                last = NULL;
                                break;
                            } else {
                                prevProc->next = p->next;
                            }
                        }
                        priorityQueue[priority].tail->next = p;
                        priorityQueue[priority].tail = p;
                        p->qtail[priority]++;
                        p->ticks = 0;
                        last = NULL;
                        p->next = NULL;
                    }
                    break;
                } else if (p->state != RUNNABLE){
                    // need to remove the process because it is unused
                    //p->ticks = 0;
                    deleteFromQueue(p, priority);
                    //enqueueProc()
                    p = p->next;
                } else {
                    prevProc = p;
                    last = p;
                    p = p->next;
                }
            }
        }
    release(&ptable.lock);
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;
  
  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan){
        p->state = RUNNABLE;
        deleteFromQueue(p, p->priority);
        enqueueProc(p, p->priority);
        p->qtail[p->priority]++;

        p->ticks = 0;
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

// This sets the priority of the specified PID to pri
// return -1 if pri or PID are invalid
int
setpri(int PID, int pri){

    if (pri < 0 || pri > 3) {
        return -1;
    }
    acquire(&ptable.lock);
    struct proc *p;

    for (int i = 3; i >= 0; i--){
        struct proc *prevProc = NULL;
        for (p = priorityQueue[i].head; p != NULL;) {

            if( p->pid == PID ){
                if (p->priority == pri){
                    // TODO: PRINT ERROR MESSAGE
                    return -1;
                }
                p->priority = pri;
                p->ticks = 0;
                if (p == priorityQueue[i].head) {
                    // ONLY ONE ITEM ON QUEUE BEING MOVED TO ANOTHER QUEUE
                    priorityQueue[i].head = p->next;
                } else if (p == priorityQueue[i].tail) {
                    // Moving tail of queue to another queue
                    prevProc->next = NULL;
                    priorityQueue[i].tail = prevProc;
                } else {
                    prevProc->next = p->next;
                }

                if (priorityQueue[pri].head == NULL){
                    priorityQueue[pri].head = p;
                    priorityQueue[pri].tail = p;
                }else {
                    priorityQueue[pri].tail->next = p;
                    priorityQueue[pri].tail = p;
                }

                p->next = NULL;
                release(&ptable.lock);
                return 0;
            }
            prevProc = p;
            p = p->next;
        }
    }

    release(&ptable.lock);
    return -1;
}

// returns the current priority of the specified PID.
// If the PID is not valid, it returns -1
int
getpri(int PID){
    struct proc *p;
    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == PID) {
            release(&ptable.lock);
            return p->priority;
        }
    }
    release(&ptable.lock);
    return -1;
}

//
int
fork2(int pri) {

    if (pri < 0 || pri > 3) {
        // TODO: PRINT ERROR MESSAGE
        return -1;
    }
    int i, pid;
    struct proc *np;
    struct proc *curproc = myproc();

    // Allocate process.
    if((np = allocproc()) == 0){
        return -1;
    }

    // Copy process state from proc.
    if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
    np->parent = curproc;
    *np->tf = *curproc->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
        if(curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));

    pid = np->pid;


    if (priorityQueue[pri].head == NULL && priorityQueue[pri].tail == NULL) {
        priorityQueue[pri].head = np;
        priorityQueue[pri].tail = np;
        
    } else {
        priorityQueue[pri].tail->next = np;
        priorityQueue[pri].tail = np;
    }
    np->qtail[pri]++;
    np->next = NULL;
    np->priority = pri;

    acquire(&ptable.lock);
    np->state = RUNNABLE;
    release(&ptable.lock);


    return pid;
}

void printQueue() {
    // helper method for printing the current pqueue
    struct proc *p;

    for (int i = 0; i < 4; i++){
        for (p = priorityQueue[i].head; p != NULL;){
            cprintf("PID: %d Proc: %p  Next: %p Head: %p Tail: %p\n", p->pid, p, p->next, priorityQueue[i].head, priorityQueue[i].tail);
            //cprintf("PID: %d PRIORITY: %d \n", p->pid, p->priority);
            p = p->next;
        }
    }
}


//void getpinfohelper() {
//
//
//    for (int i = 0; i < NPROC; i++){
//        struct proc proc = ptable.proc[i];
//        int isinuse = proc.state != UNUSED && proc.state != ZOMBIE && proc.state != EMBRYO;
//        fpstat.inuse[i] = isinuse;
//        fpstat.pid[i] = proc.pid;
//        fpstat.priority[i] = proc.priority;
//        fpstat.state[i] = proc.state;
//        if (isinuse) {
//            for (int j = 0; j < 4; j++) {
//                fpstat.ticks[i][j] = proc.agg_ticks[j];
//                fpstat.qtail[i][j] = proc.qtail[j];
//            }
//        }
//    }
//
//
//
//}


// returns 0 on success and -1 on failure
int
getpinfo(struct pstat *pstat){

    if (pstat == NULL) {
        return -1;
    }

    acquire(&ptable.lock);
    for (int i = 0; i < NPROC; i++){
        struct proc proc = ptable.proc[i];
        int isinuse = proc.state != UNUSED && proc.state != ZOMBIE && proc.state != EMBRYO;
        pstat->inuse[i] = isinuse;
        pstat->pid[i] = proc.pid;
        pstat->priority[i] = proc.priority;
        pstat->state[i] = proc.state;
        if (isinuse) {
            for (int j = 0; j < 4; j++) {
                
                pstat->ticks[i][j] = proc.agg_ticks[j];
                pstat->qtail[i][j] = proc.qtail[j];
            }
        }
    }

//    for(int i = 0; i < NPROC; i++) {
//        for (int j = 0; j < 4; j++) {
//            if (pstat->ticks[i][j] != 0)
//                cprintf("%d   %d  Priority: %d \n", pstat->pid[i], pstat->ticks[i][j], pstat->priority[i]);
//        }
//    }

    release(&ptable.lock);
    return 0;
}
