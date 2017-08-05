# Based on recommendations from:
# http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project#Recommended_settings
# https://wiki.gentoo.org/wiki/Hardened/Hardened_Kernel_Project
#
# Dangerous features that can be permanently (for the boot session) disabled at
# boot via sysctl or kernel cmdline are left enabled here, for improved
# flexibility.

{ stdenv, version }:

with stdenv.lib;

assert (versionAtLeast version "4.9");

''
# Report BUG() conditions and kill the offending process.
BUG y

${optionalString (stdenv.system == "x86_64-linux") ''
  DEFAULT_MMAP_MIN_ADDR 65536 # Prevent allocation of first 64K of memory

  # Reduce attack surface by disabling various emulations
  IA32_EMULATION n
  X86_X32 n
  MODIFY_LDT_SYSCALL n

  VMAP_STACK y # Catch kernel stack overflows

  # Randomize position of kernel and memory.
  RANDOMIZE_BASE y
  RANDOMIZE_MEMORY y

  # Modern libc no longer needs a fixed-position mapping in userspace, remove it as a possible target.
  LEGACY_VSYSCALL_NONE y
''}

# Make sure kernel page tables have safe permissions.
DEBUG_KERNEL y

${optionalString (versionOlder version "4.11") ''
  DEBUG_RODATA y
  DEBUG_SET_MODULE_RONX y
''}

${optionalString (versionAtLeast version "4.11") ''
  GCC_PLUGIN_STRUCTLEAK y # A port of the PaX structleak plugin
''}

# Report any dangerous memory permissions (not available on all archs).
DEBUG_WX y

# Do not allow direct physical memory access (but if you must have it, at least enable STRICT mode...)
# DEVMEM is not set
STRICT_DEVMEM y
IO_STRICT_DEVMEM y

# Perform additional validation of various commonly targeted structures.
DEBUG_CREDENTIALS y
DEBUG_NOTIFIERS y
DEBUG_LIST y
DEBUG_SG y
BUG_ON_DATA_CORRUPTION y
SCHED_STACK_END_CHECK y

# Provide userspace with seccomp BPF API for syscall attack surface reduction.
SECCOMP y
SECCOMP_FILTER y

# Provide userspace with ptrace ancestry protections.
SECURITY y
SECURITY_YAMA y

# Perform usercopy bounds checking.
HARDENED_USERCOPY y

# Randomize allocator freelists.
SLAB_FREELIST_RANDOM y

# Wipe higher-level memory allocations when they are freed (needs "page_poison 1" command line below).
# (If you can afford even more performance penalty, leave PAGE_POISONING_NO_SANITY n)
PAGE_POISONING y
PAGE_POISONING_NO_SANITY y
PAGE_POISONING_ZERO y

# Reboot devices immediately if kernel experiences an Oops.
PANIC_ON_OOPS y
PANIC_TIMEOUT -1

# Keep root from altering kernel memory via loadable modules.
# MODULES is not set

GCC_PLUGINS y # Enable gcc plugin options

# Disable various dangerous settings
ACPI_CUSTOM_METHOD n # Allows writing directly to physical memory
PROC_KCORE n # Exposes kernel text image layout
INET_DIAG n # Has been used for heap based attacks in the past

# Use -fstack-protector-strong (gcc 4.9+) for best stack canary coverage.
CC_STACKPROTECTOR_REGULAR n
CC_STACKPROTECTOR_STRONG y
''
