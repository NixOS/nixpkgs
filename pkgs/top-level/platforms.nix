{ system, pkgs}:
with pkgs;
{
  pc = assert system == "i686-linux" || system == "x86_64-linux"; {
    name = "pc";
    uboot = null;
    kernelBaseConfig = "defconfig";
    kernelExtraConfig =
      ''
        # Virtualisation (KVM, Xen...).
        PARAVIRT_GUEST y
        KVM_CLOCK y
        KVM_GUEST y
        XEN y
        KSM y

        # We need 64 GB (PAE) support for Xen guest support.
        HIGHMEM64G? y
      '';
  };

  sheevaplug = assert system == "armv5tel-linux"; {
    name = "sheevaplug";
    inherit uboot;
  };

  platformVersatileARM = assert system == "armv5tel-linux"; {
    name = "versatileARM";
    uboot = null;
  };
}
