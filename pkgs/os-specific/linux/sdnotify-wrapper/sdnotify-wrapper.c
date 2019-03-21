/*
   Copyright: (C)2015-2017 Laurent Bercot.  http://skarnet.org/
   ISC license. See http://opensource.org/licenses/ISC

   Build-time requirements: skalibs.  http://skarnet.org/software/skalibs/
   Run-time requirements: none, if you link skalibs statically.
 
   Compilation:
     gcc -o sdnotify-wrapper -L/usr/lib/skalibs sdnotify-wrapper.c -lskarnet
   Use /usr/lib/skalibs/libskarnet.a instead of -lskarnet to link statically.
   Adapt gcc's -I and -L options to your skalibs installation paths.

   Usage: if a daemon would be launched by systemd as "foobard args...",
   launch it as "sdnotify-wrapper foobard args..." instead, and you can now
   tell systemd that this daemon supports readiness notification.

   Instead of using sd_notify() and having to link against the systemd
   library, the daemon notifies readiness by writing whatever it wants
   to a file descriptor (by default: stdout), then a newline. (Then it
   should close that file descriptor.) The simplest way is something like
   int notify_readiness() { write(1, "\n", 1) ; close(1) ; }
   This mechanism is understandable by any notification readiness framework.

   Readiness notification occurs when the newline is written, not when
   the descriptor is closed; but since sdnotify-wrapper stops reading
   after the first newline and will exit, any subsequent writes will
   fail and it's best to simply close the descriptor right away.

   sdnotify-wrapper sees the notification when it occurs and sends it
   to systemd using the sd_notify format.

   Options:
     -d fd: the daemon will write its notification on descriptor fd.
     Default is 1.
     -f: do not doublefork. Use if the daemon waits for children it does
     not know it has (for instance, superservers do this). When in doubt,
     do not use that option, or you may have a zombie hanging around.
     -t timeout: if the daemon has not sent a notification after timeout
     milliseconds, give up and exit; systemd will not be notified.
     -k: keep the NOTIFY_SOCKET environment variable when execing into the
     daemon. By default, the variable is unset: the daemon should not need it.

   Notes:
     sdnotify-wrapper does not change the daemon's pid. It runs as a
     (grand)child of the daemon.
     If the NOTIFY_SOCKET environment variable is not set, sdnotify-wrapper
     does nothing - it only execs into the daemon.
     sdnotify-wrapper is more liberal than sd_notify(). It will accept
     a relative path in NOTIFY_SOCKET.
*/


#include <sys/types.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <skalibs/uint64.h>
#include <skalibs/types.h>
#include <skalibs/bytestr.h>
#include <skalibs/sgetopt.h>
#include <skalibs/strerr2.h>
#include <skalibs/env.h>
#include <skalibs/allreadwrite.h>
#include <skalibs/tai.h>
#include <skalibs/iopause.h>
#include <skalibs/djbunix.h>
#include <skalibs/webipc.h>

#define USAGE "sdnotify-wrapper [ -d fd ] [ -f ] [ -t timeout ] [ -k ] prog..."
#define dieusage() strerr_dieusage(100, USAGE)

#define VAR "NOTIFY_SOCKET"

static inline int ipc_sendto (int fd, char const *s, size_t len, char const *path)
{
  struct sockaddr_un sa ;
  size_t l = strlen(path) ;
  if (l > IPCPATH_MAX) return (errno = ENAMETOOLONG, 0) ;
  memset(&sa, 0, sizeof sa) ;
  sa.sun_family = AF_UNIX ;
  memcpy(sa.sun_path, path, l+1) ;
  if (path[0] == '@') sa.sun_path[0] = 0 ;
  return sendto(fd, s, len, MSG_NOSIGNAL, (struct sockaddr *)&sa, sizeof sa) >= 0 ;
}

static inline void notify_systemd (pid_t pid, char const *socketpath)
{
  size_t n = 16 ;
  char fmt[16 + PID_FMT] = "READY=1\nMAINPID=" ;
  int fd = ipc_datagram_b() ;
  if (fd < 0) strerr_diefu1sys(111, "create socket") ;
  n += pid_fmt(fmt + n, pid) ;
  fmt[n++] = '\n' ;
  if (!ipc_sendto(fd, fmt, n, socketpath))
    strerr_diefu2sys(111, "send notification message to ", socketpath) ;
  close(fd) ;
}

static inline int run_child (int fd, unsigned int timeout, pid_t pid, char const *s)
{
  char dummy[4096] ;
  iopause_fd x = { .fd = fd, .events = IOPAUSE_READ } ;
  tain_t deadline ;
  tain_now_g() ;
  if (timeout) tain_from_millisecs(&deadline, timeout) ;
  else deadline = tain_infinite_relative ;
  tain_add_g(&deadline, &deadline) ;
  for (;;)
  {
    int r = iopause_g(&x, 1, &deadline) ;
    if (r < 0) strerr_diefu1sys(111, "iopause") ;
    if (!r) return 99 ;
    r = sanitize_read(fd_read(fd, dummy, 4096)) ;
    if (r < 0)
      if (errno == EPIPE) return 1 ;
      else strerr_diefu1sys(111, "read from parent") ;
    else if (r && memchr(dummy, '\n', r)) break ;
  }
  close(fd) ;
  notify_systemd(pid, s) ;
  return 0 ;
}

int main (int argc, char const *const *argv, char const *const *envp)
{
  char const *s = env_get2(envp, VAR) ;
  unsigned int fd = 1 ;
  unsigned int timeout = 0 ;
  int df = 1, keep = 0 ;
  PROG = "sdnotify-wrapper" ;
  {
    subgetopt_t l = SUBGETOPT_ZERO ;
    for (;;)
    {
      register int opt = subgetopt_r(argc, argv, "d:ft:k", &l) ;
      if (opt == -1) break ;
      switch (opt)
      {
        case 'd' : if (!uint0_scan(l.arg, &fd)) dieusage() ; break ;
        case 'f' : df = 0 ; break ;
        case 't' : if (!uint0_scan(l.arg, &timeout)) dieusage() ; break ;
        case 'k' : keep = 1 ; break ;
        default : dieusage() ;
      }
    }
    argc -= l.ind ; argv += l.ind ;
  }
  if (!argc) dieusage() ;

  if (!s) xpathexec_run(argv[0], argv, envp) ;
  else
  {
    pid_t parent = getpid() ;
    pid_t child ;
    int p[2] ;
    if (pipe(p) < 0) strerr_diefu1sys(111, "pipe") ;
    child = df ? doublefork() : fork() ;
    if (child < 0) strerr_diefu1sys(111, df ? "doublefork" : "fork") ;
    else if (!child)
    {
      PROG = "sdnotify-wrapper (child)" ;
      close(p[1]) ;
      return run_child(p[0], timeout, parent, s) ;
    }
    close(p[0]) ;
    if (fd_move((int)fd, p[1]) < 0) strerr_diefu1sys(111, "move descriptor") ;
    if (keep) xpathexec_run(argv[0], argv, envp) ;
    else xpathexec_r(argv, envp, env_len(envp), VAR, sizeof(VAR)) ;
  }
}
