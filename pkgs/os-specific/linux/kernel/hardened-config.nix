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

${optionalString (versionAtLeast version "4.10") ''
  BUG_ON_DATA_CORRUPTION y
''}

${optionalString (stdenv.hostPlatform.platform.kernelArch == "x86_64") ''
  DEFAULT_MMAP_MIN_ADDR 65536 # Prevent allocation of first 64K of memory

  # Reduce attack surface by disabling various emulations
  IA32_EMULATION n
  X86_X32 n
  # Note: this config depends on EXPERT y and so will not take effect, hence
  # it is left "optional" for now.
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

# Mark LSM hooks read-only after init.  SECURITY_WRITABLE_HOOKS n
# conflicts with SECURITY_SELINUX_DISABLE y; disabling the latter
# implicitly marks LSM hooks read-only after init.
#
# SELinux can only be disabled at boot via selinux=0
#
# We set SECURITY_WRITABLE_HOOKS n primarily for documentation purposes; the
# config builder fails to detect that it has indeed been unset.
${optionalString (versionAtLeast version "4.12") ''
  SECURITY_SELINUX_DISABLE n
  SECURITY_WRITABLE_HOOKS? n
''}

DEBUG_WX y # boot-time warning on RWX mappings
${optionalString (versionAtLeast version "4.11") ''
  STRICT_KERNEL_RWX y
''}

# Stricter /dev/mem
STRICT_DEVMEM? y
IO_STRICT_DEVMEM? y

# Perform additional validation of commonly targeted structures.
DEBUG_CREDENTIALS y
DEBUG_NOTIFIERS y
DEBUG_LIST y
DEBUG_PI_LIST y # doesn't BUG()
DEBUG_SG y
SCHED_STACK_END_CHECK y

${optionalString (versionAtLeast version "4.13") ''
  REFCOUNT_FULL y
''}

# Perform usercopy bounds checking.
HARDENED_USERCOPY y
${optionalString (versionAtLeast version "4.16") ''
  HARDENED_USERCOPY_FALLBACK n  # for full whitelist enforcement
''}

# Randomize allocator freelists.
SLAB_FREELIST_RANDOM y

${optionalString (versionAtLeast version "4.14") ''
  SLAB_FREELIST_HARDENED y
''}

# Allow enabling slub/slab free poisoning with slub_debug=P
SLUB_DEBUG y

# Wipe higher-level memory allocations on free() with page_poison=1
PAGE_POISONING y
PAGE_POISONING_NO_SANITY y
PAGE_POISONING_ZERO y

# Reboot devices immediately if kernel experiences an Oops.
PANIC_ON_OOPS y
PANIC_TIMEOUT -1

GCC_PLUGINS y # Enable gcc plugin options
# Gather additional entropy at boot time for systems that may not have appropriate entropy sources.
GCC_PLUGIN_LATENT_ENTROPY y

${optionalString (versionAtLeast version "4.11") ''
  GCC_PLUGIN_STRUCTLEAK y # A port of the PaX structleak plugin
''}
${optionalString (versionAtLeast version "4.14") ''
  GCC_PLUGIN_STRUCTLEAK_BYREF_ALL y # Also cover structs passed by address
''}
${optionalString (versionAtLeast version "4.20") ''
  GCC_PLUGIN_STACKLEAK y # A port of the PaX stackleak plugin
''}

${optionalString (versionAtLeast version "4.13") ''
  GCC_PLUGIN_RANDSTRUCT y # A port of the PaX randstruct plugin
  GCC_PLUGIN_RANDSTRUCT_PERFORMANCE y
''}

# Disable various dangerous settings
ACPI_CUSTOM_METHOD n # Allows writing directly to physical memory
PROC_KCORE n # Exposes kernel text image layout
INET_DIAG n # Has been used for heap based attacks in the past

# Use -fstack-protector-strong (gcc 4.9+) for best stack canary coverage.
${optionalString (versionOlder version "4.18") ''
  CC_STACKPROTECTOR_REGULAR n
  CC_STACKPROTECTOR_STRONG y
''}

# Enable compile/run-time buffer overflow detection ala glibc's _FORTIFY_SOURCE
${optionalString (versionAtLeast version "4.13") ''
  FORTIFY_SOURCE y
''}
''
