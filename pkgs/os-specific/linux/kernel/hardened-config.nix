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

with import ../../../../lib/kernel.nix { inherit (stdenv) lib; inherit version; };

{
  ACPI_CUSTOM_METHOD                    = no;
  BUG                                   = yes;
  BUG_ON_DATA_CORRUPTION                = whenAtLeast "4.10" yes;
  CC_STACKPROTECTOR_REGULAR             = whenOlder "4.18" no;
  CC_STACKPROTECTOR_STONG               = whenOlder "4.18" yes;
  DEBUG_CREDENTIALS                     = yes;
  DEBUG_LIST                            = yes;
  DEBUG_NOTIFIERS                       = yes;
  DEBUG_PI_LIST                         = yes;
  DEBUG_RODATA                          = whenOlder "4.11" yes;
  DEBUG_SET_MODULE_RONX                 = whenOlder "4.11" yes;
  DEBUG_SG                              = yes;
  DEBUG_WX                              = yes;
  FORTIFY_SOURCE                        = whenAtLeast "4.13" yes;
  GCC_PLUGINS                           = yes;
  GCC_PLUGIN_LATENT_ENTROPY             = yes;
  GCC_PLUGIN_RANDSTRUCT                 = whenAtLeast "4.13" yes;
  GCC_PLUGIN_RANDSTRUCT_PERFORMANCE     = whenAtLeast "4.13" yes;
  GCC_PLUGIN_STACKLEAK                  = whenAtLeast "4.20" yes;
  GCC_PLUGIN_STRUCTLEAK                 = whenAtLeast "4.11" yes;
  GCC_PLUGIN_STRUCTLEAK_BYREF_ALL       = whenAtLeast "4.14" yes;
  HARDENED_USERCOPY                     = yes;
  HARDENED_USERCOPY_FALLBACK            = whenAtLeast "4.16" yes;
  INET_DIAG                             = no;
  IO_STRICT_DEVMEM                      = option yes;
  PAGE_POISONING                        = yes;
  PAGE_POISONING_NO_SANITY              = yes;
  PAGE_POISONING_ZERO                   = yes;
  PANIC_ON_OOPS                         = yes;
  PANIC_TIMEOUT                         = "-1";
  PROC_KCORE                            = no;
  REFCOUNT_FULL                         = whenAtLeast "4.13" yes;
  SCHED_STACK_END_CHECK                 = yes;
  SECURITY_SELINUX_DISABLE              = no;
  SECURITY_WRITABLE_HOOKS               = option no;
  SLAB_FREELIST_HARDENED                = whenAtLeast "4.14" yes;
  SLAB_FREELIST_RANDOM                  = yes;
  SLUB_DEBUG                            = yes;
  STRICT_DEVMEM                         = option yes;
  STRICT_KERNEL_RWX                     = whenAtLeast "4.11" yes;
} // optionalAttrs (stdenv.hostPlatform.system == "x86_64-linux" || stdenv.hostPlatform.system == "aarch64-linux") {
  DEFAULT_MMAP_MIN_ADDR                 = "65536"; # Prevent allocation of first 64k of memory
  IA32_EMULATION                        = no;
  LEGACY_VSYSCALL_NONE                  = yes;
  MODIFY_LDT_SYSCALL                    = option no;
  RANDOMIZE_BASE                        = yes;
  RANDOMIZE_MEMORY                      = yes;
  X86_X32                               = no;
  VMAP_STACK                            = yes;
}
