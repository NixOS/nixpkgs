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
GCC_PLUGINS y # Enable gcc plugin options

${optionalString (versionAtLeast version "4.11") ''
  GCC_PLUGIN_STRUCTLEAK y # A port of the PaX structleak plugin
''}

DEBUG_WX y # A one-time check for W+X mappings at boot; doesn't do anything beyond printing a warning

${optionalString (versionAtLeast version "4.10") ''
  BUG_ON_DATA_CORRUPTION y # BUG if kernel struct validation detects corruption
''}

# Additional validation of commonly targetted structures
DEBUG_CREDENTIALS y
DEBUG_NOTIFIERS y
DEBUG_LIST y
DEBUG_SG y

HARDENED_USERCOPY y # Bounds check usercopy

# Wipe on free with page_poison=1
PAGE_POISONING y
PAGE_POISONING_NO_SANITY y
PAGE_POISONING_ZERO y

CC_STACKPROTECTOR_REGULAR n
CC_STACKPROTECTOR_STRONG y

# Stricter /dev/mem
STRICT_DEVMEM y
IO_STRICT_DEVMEM y

# Disable various dangerous settings
ACPI_CUSTOM_METHOD n # Allows writing directly to physical memory
PROC_KCORE n # Exposes kernel text image layout
INET_DIAG n # Has been used for heap based attacks in the past

${optionalString (stdenv.system == "x86_64-linux") ''
  DEFAULT_MMAP_MIN_ADDR 65536 # Prevent allocation of first 64K of memory

  # Reduce attack surface by disabling various emulations
  IA32_EMULATION n
  X86_X32 n

  VMAP_STACK y # Catch kernel stack overflows
''}

''
