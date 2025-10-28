#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"


void pop(deque *q){
    acquire(&q->lock);
    for(int i = 0;i < q->end-1;i++){
        q->n[i] = q->n[i+1];
    }
    q->end--;
    release(&q->lock);
    return;
}


void push_front(deque *q,struct proc* x){
    acquire(&q->lock);
    if(q->end == NPROC){
        panic("Error!");
        return;
    }
    for(int i = 0;i < q->end;i++){
        q->n[i+1] = q->n[i];
    }
    q->n[0] = x;
    q->end++;
    release(&q->lock);
}

void push_back(deque *q,struct proc* x){
    acquire(&q->lock);
    if (q->end == NPROC){
        panic("Error!");
        return;
    }
    q->n[q->end] = x;
    q->end++;
    release(&q->lock);
}


struct proc *front(deque *q){
    acquire(&q->lock);
    if (q->end == 0){
        return 0;
    }

    struct proc* p = q->n[0];
    release(&q->lock);
    return p;
}


int size(deque *q){
    acquire(&q->lock);
    int sz = q->end;
    release(&q->lock);
    return sz;
}


void delete (deque *q, uint pid){
    acquire(&q->lock);
    int flag = 0;
    for (int i = 0; i < q->end; i++){
        
        if (pid == q->n[i]->pid){
            flag = 1;
        }

        if (flag == 1 && i != NPROC){
            q->n[i] = q->n[i + 1];
        }
    }
    q->end--;
    release(&q->lock);
    return;
}