# Based on recommendations from:
# http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project#Recommended_settings
# https://wiki.gentoo.org/wiki/Hardened/Hardened_Kernel_Project
#
# Dangerous features that can be permanently (for the boot session) disabled at
# boot via sysctl or kernel cmdline are left enabled here, for improved
# flexibility.
#
# See also <nixos/modules/profiles/hardened.nix>

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
  MODIFY_LDT_SYSCALL? n

  VMAP_STACK y # Catch kernel stack overflows

  # Randomize position of kernel and memory.
  RANDOMIZE_BASE y
  RANDOMIZE_MEMORY y

  # Disable legacy virtual syscalls by default (modern glibc use vDSO instead).
  #
  # Note that the vanilla default is to *emulate* the legacy vsyscall mechanism,
  # which is supposed to be safer than the native variant (wrt. ret2libc), so
  # disabling it mainly helps reduce surface.
  LEGACY_VSYSCALL_NONE y
''}

# Safer page access permissions (wrt. code injection).  Default on >=4.11.
${optionalString (versionOlder version "4.11") ''
  DEBUG_RODATA y
  DEBUG_SET_MODULE_RONX y
''}

# Mark LSM hooks read-only after init.  Conflicts with SECURITY_SELINUX_DISABLE
# (disabling SELinux at runtime); hence, SELinux can only be disabled at boot
# via the selinux=0 boot parameter.
${optionalString (versionAtLeast version "4.12") ''
  SECURITY_SELINUX_DISABLE n
  SECURITY_WRITABLE_HOOKS n
''}

DEBUG_WX y # boot-time warning on RWX mappings

# Stricter /dev/mem
STRICT_DEVMEM y
IO_STRICT_DEVMEM y

# Perform additional validation of commonly targeted structures.
DEBUG_CREDENTIALS y
DEBUG_NOTIFIERS y
DEBUG_LIST y
DEBUG_SG y
SCHED_STACK_END_CHECK y
BUG_ON_DATA_CORRUPTION y

# Perform usercopy bounds checking.
HARDENED_USERCOPY y

# Randomize allocator freelists.
SLAB_FREELIST_RANDOM y

# Wipe higher-level memory allocations on free() with page_poison=1
PAGE_POISONING y
PAGE_POISONING_NO_SANITY y
PAGE_POISONING_ZERO y

# Reboot devices immediately if kernel experiences an Oops.
PANIC_ON_OOPS y
PANIC_TIMEOUT -1

GCC_PLUGINS y # Enable gcc plugin options

${optionalString (versionAtLeast version "4.11") ''
  GCC_PLUGIN_STRUCTLEAK y # A port of the PaX structleak plugin
''}

# Disable various dangerous settings
ACPI_CUSTOM_METHOD n # Allows writing directly to physical memory
PROC_KCORE n # Exposes kernel text image layout
INET_DIAG n # Has been used for heap based attacks in the past

# Use -fstack-protector-strong (gcc 4.9+) for best stack canary coverage.
CC_STACKPROTECTOR_REGULAR n
CC_STACKPROTECTOR_STRONG y
''
