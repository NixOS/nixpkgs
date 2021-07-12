#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <sys/ptrace.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/user.h>
#include <unistd.h>
#include <stdbool.h>

#define TRY(thing) do { if ((thing) < 0) { fprintf(stderr, #thing ": %s (%d)\n", strerror(errno), errno); return 1; } } while (0)

static int syscall_start(const pid_t child, struct user_regs_struct *regs) {
	long sc = regs->orig_eax;
	const long *const regn = (void*)regs;

	// which of this syscall's args is a path? (return if none)
	int regi;
	switch (sc) {
	case SYS_open:
	case SYS_stat64:
	case SYS_stat:
	case SYS_lstat64:
	case SYS_lstat:
	case SYS_execve:
		regi = 0;
		break;
	case SYS_openat:
	case SYS_access:
		regi = 1;
		break;
	default: return 0;
	}

	// strcpy the path from tracee's address space
	char buf[129*4]; // XXX: arbitrary limit
	long ppath = regn[regi];
	long offs = ppath & 0x3;
	ppath &= ~0x3;
	long *bufn = (long*)&buf;
	long mask = (long)-1 >> (offs * 8);
	for (int i=0; i<128; i++) {
		errno = 0;
		long datum = ptrace(PTRACE_PEEKDATA, child, ppath + 4 * i, 0);
		TRY( errno );
		bufn[i] = datum;
		bufn[i+1] = 0;
		long d0 = mask | datum;
		mask = 0;
		if (!((d0 & 0xff) && (d0 & 0xff00) && (d0 & 0xff0000) && (d0 & 0xff000000)))
			break;
	}
	const char *const path = &buf[offs];

	// rewrite the path (or return if no change)
	char subst[129*4]; // XXX: arbitrary limit
	if (!strncmp(path, "/usr/share/", 11) || !strncmp(path, "/usr/bin/", 9)) {
		strcpy(subst, OUT);
		int subst_len = strlen(OUT);
		strcpy(subst+subst_len, path+4); // XXX: buffer overflow
	} else if (!strncmp(path, "/usr/lib/", 9)) {
		strcpy(subst, OUT "/lib32");
		int subst_len = strlen(OUT "/lib32");
		strcpy(subst+subst_len, path+8); // XXX: buffer overflow
	} else {
		return 0;
	}
	// XXX: should ensure buffer is word-aligned...
	const long *substn = (long*)subst;

	// blit rewritten path into tracee's unused stack space; replace syscall arg to point to it
	int i = strlen(subst) / 4 + 1;
	long pbuf = regs->esp - (4 * i);
	for (; i>0; i--) {
		TRY( ptrace(PTRACE_POKEDATA, child, pbuf + 4 * (i - 1), substn[(i - 1)]) );
	}
	TRY( ptrace(PTRACE_POKEUSER, child, 4 * regi, pbuf) );
	return 0;
}

struct child_state {
	pid_t pid;
	bool in_syscall;
};

static int tracer_main(pid_t init_pid) {
	int status;

	struct child_state tracee[16];
	tracee[0].pid = init_pid;
	tracee[0].in_syscall = true;
	int tracees = 1;

	TRY( ptrace(PTRACE_SEIZE, init_pid, 0, 0
				| PTRACE_O_TRACECLONE | PTRACE_O_TRACEFORK | PTRACE_O_TRACEVFORK
				| PTRACE_O_TRACEEXEC
				| PTRACE_O_TRACESYSGOOD
				) );

	// wake the child from its self-delivered SIGSTOP
	// - wait for the stop
	TRY( waitpid(init_pid, &status, WUNTRACED) );
	// - resume
	TRY( ptrace(PTRACE_CONT, init_pid, 0, 0) );

	for (;;) {
		pid_t child = waitpid(-1, &status, WUNTRACED);
		TRY( child );
		int c = -1;
		for (int i=0; i<tracees; i++) {
			if (child == tracee[i].pid) {
				c = i;
				break;
			}
		}
		TRY( c );
		long sig = 0;
		if (WIFEXITED(status)) {
			int child_code = WEXITSTATUS(status);
			//return child_code; // FIXME
			tracee[c] = tracee[--tracees];
			if (!tracees) return 0;
			continue;
		} else if ((status >> 8 == (SIGTRAP | PTRACE_EVENT_FORK<<8))
			|| (status >> 8 == (SIGTRAP | PTRACE_EVENT_CLONE<<8))
			|| (status >> 8 == (SIGTRAP | PTRACE_EVENT_VFORK<<8))) {
			unsigned long pid;
			TRY( ptrace(PTRACE_GETEVENTMSG, child, 0, &pid) );
			int c = tracees++;
			TRY( 16 - tracees );
			tracee[c].pid = pid;
			tracee[c].in_syscall = false;
		} else if (WIFSTOPPED(status)) {
			if (WSTOPSIG(status) == (SIGTRAP | 0x80)) {
				struct user_regs_struct regs;
				TRY( ptrace(PTRACE_GETREGS, child, 0, &regs) );
				if (!tracee[c].in_syscall) {
					TRY( syscall_start(child, &regs) );
				}
				tracee[c].in_syscall = !tracee[c].in_syscall;
			} else {
				sig = WSTOPSIG(status);
				// XXX: shouldn't set sig if it's actually a group-stop?
			}
		}
		TRY( ptrace(PTRACE_SYSCALL, child, 0, sig) );
	}
	return 0;
}

int main(int argc, char *const argv[]) {
	char *subargv[argc + 1];
	subargv[0] = EXEC;
	for (int i=1; i<argc + 1; i++) {
		subargv[i] = argv[i];
	}
	pid_t child = fork();
	TRY( child );
	if (child == 0) {
		// stop until tracer is ready
		raise(SIGSTOP);
		execv(EXEC, subargv);
		// no return unless fail
		fprintf(stderr, "%s: failed to exec: %s\n", EXEC, strerror(errno));
		return 1;
	} else {
		return tracer_main(child);
	}
}
