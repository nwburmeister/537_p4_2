//
// Created by nikolas on 10/14/19.
//


#include "types.h"
#include "user.h"
#include "param.h"
#include "mmu.h"
#include "proc.h"
#include "pstat.h"

int status;

void roundRobin(int timeslice, int iterations, char *job, int jobcount){


    char **ptr = &job;
    struct pstat *pstat = malloc(sizeof(struct pstat));
    int jcount = 0;

    while ( jcount < jobcount ) {
        int pid = fork2(2);
        if (pid < 0) {
            exit();
        } else if (pid == 0) {
            exec(job, ptr);
        } else if (pid > 0) {
            // getpinfo(pstat);
        }
        jcount++;
    }

    for (int i = 0; i < iterations; i++){
        getpinfo(pstat);
        for(int j = 0; j < NPROC; j++) {
            if (pstat->priority[j] == 2) {
//                int pri = getpri(pstat->pid[j]);
                //setpri(pstat->pid[j], 3);
            }
        }
        sleep(timeslice);
    }



    //wait();
    getpinfo(pstat);
    for (int i = 0; i < NPROC; i++) {
        for (int k = 0; k < 4; k++){
            // printf(1, "IS IN-USE %d XV6_SCHEDULER\t \t level %d ticks used %d\n", pstat->inuse[i], k, pstat->ticks[i][k]);
            // printf(1, "XV6_SCHEDULER\t \t level %d ticks used %d\n", k, pstat->ticks[i][k]);
        }

        if (pstat->pid[i] > 3) {
            //printf(1, "%s\n", "entered");

            //printf(1, "%s\n", "here");
            wait();
            kill(pstat->pid[i]);
        }
    }


}

int main(int argc, char *argv[]) {
    if(argc != 5) {
        // TODO: print error message
        exit();
    }

    int timeslice = atoi(argv[1]);
    int iterations = atoi(argv[2]);
    char *job = malloc(sizeof(char) * (strlen(argv[3]) + 1));
    strcpy(job, argv[3]);
    int jobcount = atoi(argv[4]);

    roundRobin(timeslice, iterations, job, jobcount);
    free(job);
    exit();
}