# Based on recommendations from:
# http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project#Recommended_settings
# https://wiki.gentoo.org/wiki/Hardened/Hardened_Kernel_Project
#
# The base kernel is assumed to be at least 4.9 or whatever the toplevel
# linux_hardened package expression uses.
#
# Dangerous features that can be permanently (for the boot session) disabled at
# boot via sysctl or kernel cmdline are left enabled here, for improved
# flexibility.

{ stdenv }:

with stdenv.lib;

''
GCC_PLUGINS y # Enable gcc plugin options

DEBUG_KERNEL y
DEBUG_RODATA y # Make kernel text & rodata read-only
DEBUG_WX y # A one-time check for W+X mappings at boot; doesn't do anything beyond printing a warning

# Additional validation of commonly targetted structures
DEBUG_CREDENTIALS y
DEBUG_NOTIFIERS y
DEBUG_LIST y

HARDENED_USERCOPY y # Bounds check usercopy

# Wipe on free with page_poison=1
PAGE_POISONING y
PAGE_POISONING_NO_SANITY y
PAGE_POISONING_ZERO y

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
