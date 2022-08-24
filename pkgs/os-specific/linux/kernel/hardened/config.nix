# Based on recommendations from:
# http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project#Recommended_settings
# https://wiki.gentoo.org/wiki/Hardened/Hardened_Kernel_Project
#
# Dangerous features that can be permanently (for the boot session) disabled at
# boot via sysctl or kernel cmdline are left enabled here, for improved
# flexibility.
#
# See also <nixos/modules/profiles/hardened.nix>

{ lib, version }:

with lib;
with lib.kernel;
with (lib.kernel.whenHelpers version);

assert (versionAtLeast version "4.9");

{
  # Report BUG() conditions and kill the offending process.
  BUG = yes;

  # Safer page access permissions (wrt. code injection).  Default on >=4.11.
  DEBUG_RODATA          = whenOlder "4.11" yes;
  DEBUG_SET_MODULE_RONX = whenOlder "4.11" yes;

  # Mark LSM hooks read-only after init.  SECURITY_WRITABLE_HOOKS n
  # conflicts with SECURITY_SELINUX_DISABLE y; disabling the latter
  # implicitly marks LSM hooks read-only after init.
  #
  # SELinux can only be disabled at boot via selinux=0
  #
  # We set SECURITY_WRITABLE_HOOKS n primarily for documentation purposes; the
  # config builder fails to detect that it has indeed been unset.
  SECURITY_SELINUX_DISABLE = whenAtLeast "4.12" no;
  SECURITY_WRITABLE_HOOKS  = whenAtLeast "4.12" (option no);

  STRICT_KERNEL_RWX = whenAtLeast "4.11" yes;

  # Perform additional validation of commonly targeted structures.
  DEBUG_CREDENTIALS     = yes;
  DEBUG_NOTIFIERS       = yes;
  DEBUG_PI_LIST         = whenOlder "5.2" yes; # doesn't BUG()
  DEBUG_PLIST           = whenAtLeast "5.2" yes;
  DEBUG_SG              = yes;
  SCHED_STACK_END_CHECK = yes;

  REFCOUNT_FULL = whenBetween "4.13" "5.4" yes;

  # Randomize page allocator when page_alloc.shuffle=1
  SHUFFLE_PAGE_ALLOCATOR = whenAtLeast "5.2" yes;

  # Allow enabling slub/slab free poisoning with slub_debug=P
  SLUB_DEBUG = yes;

  # Wipe higher-level memory allocations on free() with page_poison=1
  PAGE_POISONING           = yes;
  PAGE_POISONING_NO_SANITY = whenOlder "5.11" yes;
  PAGE_POISONING_ZERO      = whenOlder "5.11" yes;

  # Enable the SafeSetId LSM
  SECURITY_SAFESETID = whenAtLeast "5.1" yes;

  # Reboot devices immediately if kernel experiences an Oops.
  PANIC_TIMEOUT = freeform "-1";

  GCC_PLUGINS = yes; # Enable gcc plugin options
  # Gather additional entropy at boot time for systems that may not have appropriate entropy sources.
  GCC_PLUGIN_LATENT_ENTROPY = yes;

  GCC_PLUGIN_STRUCTLEAK = whenAtLeast "4.11" yes; # A port of the PaX structleak plugin
  GCC_PLUGIN_STRUCTLEAK_BYREF_ALL = whenAtLeast "4.14" yes; # Also cover structs passed by address
  GCC_PLUGIN_STACKLEAK = whenAtLeast "4.20" yes; # A port of the PaX stackleak plugin
  GCC_PLUGIN_RANDSTRUCT = whenAtLeast "4.13" yes; # A port of the PaX randstruct plugin
  GCC_PLUGIN_RANDSTRUCT_PERFORMANCE = whenAtLeast "4.13" yes;

  # Disable various dangerous settings
  ACPI_CUSTOM_METHOD = no; # Allows writing directly to physical memory
  PROC_KCORE         = no; # Exposes kernel text image layout
  INET_DIAG          = no; # Has been used for heap based attacks in the past

  # INET_DIAG=n causes the following options to not exist anymore, but since they are defined in common-config.nix,
  # make them optional
  INET_DIAG_DESTROY = option no;
  INET_RAW_DIAG     = option no;
  INET_TCP_DIAG     = option no;
  INET_UDP_DIAG     = option no;
  INET_MPTCP_DIAG   = option no;

  # Use -fstack-protector-strong (gcc 4.9+) for best stack canary coverage.
  CC_STACKPROTECTOR_REGULAR = lib.mkForce (whenOlder "4.18" no);
  CC_STACKPROTECTOR_STRONG  = whenOlder "4.18" yes;

  # Detect out-of-bound reads/writes and use-after-free
  KFENCE = whenAtLeast "5.12" yes;

  # CONFIG_DEVMEM=n causes these to not exist anymore.
  STRICT_DEVMEM    = option no;
  IO_STRICT_DEVMEM = option no;
}
