{ stdenv, version }:

with stdenv.lib;

''
GCC_PLUGINS y
GRKERNSEC y
GRKERNSEC_CONFIG_CUSTOM y # do custom configuration
PAX y

# PaX control
PAX_SOFTMODE y
PAX_PT_PAX_FLAGS y
PAX_XATTR_PAX_FLAGS y
PAX_EI_PAX n

# PaX Nonexecutable Pages
PAX_NOEXEC y
PAX_PAGEEXEC y
PAX_EMUTRAMP y
PAX_MPROTECT y
PAX_MPROTECT_COMPAT n
PAX_ELFRELOCS n
PAX_KERNEXEC_PLUGIN_METHOD_BTS y # See PAX_RAP

# PaX ASLR
PAX_ASLR y
PAX_RANDKSTACK y # Kernel Task Stack
PAX_RANDUSTACK y # User Stack
PAX_RANDMMAP y # Mmap without a base

# PaX Miscellaneous
PAX_MEMORY_SANITIZE y
PAX_MEMORY_STACKLEAK y # bzero stack
PAX_MEMORY_STRUCTLEAK y # bzero structs
PAX_REFCOUNT y # (re)count references
PAX_USERCOPY y # apply bounds copy_{from, to}_user
PAX_SIZE_OVERFLOW y # assert size signature on function arguments
PAX_SIZE_OVERFLOW_EXTRA n # do extra dynamic analysis
PAX_INITIFY y # free unused kernel functions
PAX_INITIFY_VERBOSE y # enable verbose mode to aid in debugging
PAX_RAP y # rop protection

# Memory Protections
GRKERNSEC_KMEM n # disable /dev/kmem, /dev/mem, /dev/port, /dev/cpu/*/msr
GRKERNSEC_IO y # ioperm restriction
GRKERNSEC_BPF_HARDEN y # harden bpf jit
GRKERNSEC_PERF_HARDEN y # /proc/sys/kernel/perf_event_paranoid => 3
GRKERNSEC_RAND_THREADSTACK y # put gap btw thread stacks
GRKERNSEC_PROC_MEMMAP y # disable /proc/self/{maps,stat}
GRKERNSEC_KSTACKOVERFLOW y # put barrier between kernel task (struct & stack)
GRKERNSEC_BRUTE y # disable brute forcing (meh?)
GRKERNSEC_MODHARDEN y # autoload modules from group=users
GRKERNSEC_HIDESYM n # hide symbols in /proc (ie kallsyms)
GRKERNSEC_RANDSTRUCT n # randomize task struct
GRKERNSEC_KERN_LOCKOUT y # Lockout violating user

# Role Based Access Control Options (RBAC)
GRKERNSEC_ACL_MAXTRIES 3 # max tries to access RBAC
GRKERNSEC_ACL_TIMEOUT 30 # timeout to retry to access RBAC

# Filesystem Protections
GRKERNSEC_PROC n # enable /proc restrictions
GRKERNSEC_LINK y # follow symlinx restrictions
GRKERNSEC_FIFO n # restrict FIFO's
GRKERNSEC_SYSFS_RESTRICT y
GRKERNSEC_ROFS y
GRKERNSEC_DEVICE_SIDECHANNEL y # prevent side-channel, timing to devices

# Kernel Audititing
GRKERNSEC_AUDIT_GROUP n # audit everybody, not just a group
GRKERNSEC_EXECLOG n # log execve(), disables, too much noise
GRKERNSEC_RESLOG y # resource limit overstep logging
GRKERNSEC_CHROOT_EXECLOG n # chroot() execve() logging
GRKERNSEC_AUDIT_PTRACE y # log ptrace()
GRKERNSEC_AUDIT_CHDIR n # log chdir()
GRKERNSEC_AUDIT_MOUNT y # log mount()
GRKERNSEC_SIGNAL y # signal SIGSEGV
GRKERNSEC_FORKFAIL y # log failed fork()
GRKERNSEC_TIME y # log time changes
GRKERNSEC_PROC_IPADDR y # put /proc/pid/ipaddr of the user
GRKERNSEC_RWXMAP_LOG y # log denied RWX mmap() calls

# Executable Protections
GRKERNSEC_DMESG n # deny dmesg(8)
GRKERNSEC_HARDEN_PTRACE y # don't attach to random process
GRKERNSEC_PTRACE_READEXEC y # ptrace() only elfs that are readable to the user
GRKERNSEC_SETXID y # enforce all threads to drop priviledges at once
GRKERNSEC_HARDEN_IPC y # harden IPC objects
GRKERNSEC_HARDEN_TTY y # harden tty
GRKERNSEC_TPE n # trusted path executions

# Network Protections
GRKERNSEC_BLACKHOLE y # network blackhole, (no RST etc)
GRKERNSEC_NO_SIMULT_CONNECT n
GRKERNSEC_SOCKET n # restict sockets to a GID

# Physical Protections
GRKERNSEC_DENYUSB n # deny new usb devices

# Sysctl Support
GRKERNSEC_SYSCTL y
GRKERNSEC_SYSCTL_DISTRO y

# Assume that appropriate sysctls are toggled once the system is up
GRKERNSEC_SYSCTL_ON n

# Logging Options
GRKERNSEC_FLOODTIME 3
GRKERNSEC_FLOODBURST 4
''
