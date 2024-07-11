#define _GNU_SOURCE

#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include <signal.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

#define JOBSRV_IOC_SET_LIMIT _IOW(0x0A, 0, unsigned)

static int r = -1, w = -1;
static char token = 0;

static void return_token()
{
    for (;;) {
        ssize_t written = written = write(w, &token, 1);
        if (written < 0 && errno == EINTR) {
            continue;
        } else if (written < 1) {
            perror("jscall token return failed");
        }
        break;
    }
}

static void handle_signal(int sig)
{
    if (w >= 0 && token != 0) {
        return_token();
        w = -1;
    }
    signal(sig, SIG_DFL);
    raise(sig);
}

static int find_separator(char** argv)
{
    for (int i = 0; argv[i]; i++) {
        if (strcmp(argv[i], "----") == 0) {
            return i;
        }
    }
    return -1;
}

static void shift_args(char** low, char** high)
{
    for (; high[0]; low++, high++) {
        low[0] = high[0];
    }
    low[0] = NULL;
}

static void shift_once(char** args)
{
    shift_args(args, args + 1);
}

static int run_child(char** argv)
{
    execvp(argv[0], argv);
    perror("execvp");
    return 1;
}

static const char* usage =
    "invocation: jscall [-F flags] <jobserver> <token-limit> <main...> ---- [def-args...] ---- [args...]\n"
    "\n"
    "runs `main... args...` with a GNU jobserver fd set in MAKEFLAGS if `jobserver`\n"
    "exists on is a nixos-jobserver endpoint. otherwise runs\n"
    "`main... def-args... args...`. if -F is given, `flags` is a space-separated\n"
    "of environment variables to add jobserver arguments to instead of MAKEFLAGS.\n"
    "\n"
    "when running with nixos-jobserver available `main` and its children are\n"
    "limited to `token-limit` tokens, which may be less than the system limit.\n"
    "\n"
    "arguments beginning with ---- are not allowed except in `args`.\n";

int main(int argc, char* argv[])
{
    // we'll later pass this to strtok, which needs it to be mutable
    char vars_raw[] = "MAKEFLAGS";
    char* vars = vars_raw;

    for (int opt; (opt = getopt(argc, argv, "+F:")) != -1; ) {
        switch (opt) {
        case 'F':
            vars = optarg;
            break;
        case '?':
        default:
            fprintf(stderr, "%s", usage);
            return 1;
        }
    }

    shift_args(argv + 1, argv + optind);
    argc -= optind - 1;

    // create a default command first by removing the separators.
    // if we can use the jobserver we'll shift the default args out of the arguments
    // list.

    char** cmd = argv + 3;
    int cmd_length = find_separator(cmd);
    if (cmd_length < 0) {
        fprintf(stderr, "main command not terminated\n\n%s", usage);
        return 1;
    } else if (cmd_length == 0) {
        fprintf(stderr, "main command not given\n\n%s", usage);
        return 1;
    }
    shift_once(cmd + cmd_length);

    char** def_args = cmd + cmd_length;
    int def_args_length = find_separator(def_args);
    if (def_args_length < 0) {
        fprintf(stderr, "def-args command not terminated\n\n%s", usage);
        return 1;
    }
    shift_once(def_args + def_args_length);

    char** args = def_args + def_args_length;

    struct stat st;
    if (stat(argv[1], &st)) {
        perror("stat() jobserver pipe");
        return 1;
    }

    unsigned token_limit;
    if (sscanf(argv[2], "%u%c", &token_limit, (char*) &token_limit) != 1) {
        fprintf(stderr, "token limit must be an unsigned integer\n");
        return 1;
    }

    // we only support nixos-jobserver files here. supporting named pipes would be possible,
    // but since we're a part of stdenv and stdenv is occasionally SIGKILLed by nix we would
    // lose tokens when using normal pipes.
    r = open(argv[1], O_RDWR);
    w = dup(r);

    if (r < 0 || w < 0) {
        fprintf(stderr, "failed to open jobserver pipe, executing without jobserver\n");
        close(r);
        close(w);
        return run_child(cmd);
    }
    if (ioctl(r, JOBSRV_IOC_SET_LIMIT, &token_limit)) {
        perror("failed to set token limit");
        fprintf(stderr, "is %s a nixos-jobserver instance? attempting to run without jobserver\n", argv[1]);
        close(r);
        close(w);
        return run_child(cmd);
    }

    for (char* flag, *toks = NULL;
            (flag = strtok_r(toks ? NULL : vars, " ", &toks)); ) {
        char* flags = getenv(flag);
        if (!flags) {
            flags = "";
        }
        if (asprintf(&flags, "%s -j --jobserver-auth=%i,%i", flags, r, w) < 0) {
            perror("asprintf");
            return 1;
        }
        if (setenv(flag, flags, 1)) {
            fprintf(stderr, "invalid environment variable %s\n", flag);
            return 1;
        }
    }

    signal(SIGINT, handle_signal);
    signal(SIGHUP, handle_signal);
    signal(SIGTERM, handle_signal);

    // older make versions use blocking read fds, newer version use nonblocking.
    // we don't need to worry about that here since we are the server and haven't given
    // any tokens to children yet.
    if (read(r, &token, 1) != 1) {
        perror("failed to acquire initial job token");
        return 1;
    }

    // set O_NONBLOCK on the jobserver file description.
    // make itself does not need this, but other tools (like cargo) expect to receive
    // nonblocking fds and get stuck when given a blocking fd.
    if (fcntl(r, F_SETFL, O_NONBLOCK)) {
        perror("fcntl");
        return 1;
    }

    pid_t p = fork();
    if (p < 0) {
        return_token();
        perror("fork");
        return 1;
    } else if (p == 0) {
        shift_args(def_args, args);
        return run_child(cmd);
    } else {
        int status;
        waitpid(p, &status, 0);

        if (WIFEXITED(status)) {
            return_token();
            return WEXITSTATUS(status);
        } else if (WIFSIGNALED(status)) {
            raise(WTERMSIG(status));
        } else {
            return_token();
            fprintf(stderr, "unexpected return from waitpid: %i\n", status);
            return 1;
        }
    }
}
