{ stdenv, fetchurl, extraConfig ? "", ... } @ args:

let
  configWithPlatform = kernelPlatform:
  ''
    # Don't include any debug features.
    DEBUG_KERNEL n

    # Support drivers that need external firmware.
    STANDALONE n

    # Make /proc/config.gz available.
    IKCONFIG_PROC y

    # Optimize with -O2, not -Os.
    CC_OPTIMIZE_FOR_SIZE n

    # Enable various subsystems.
    MTD_COMPLEX_MAPPINGS y # needed for many devices

    # Networking options.
    IP_PNP n
    IPV6_PRIVACY y

    # Filesystem options - in particular, enable extended attributes and
    # ACLs for all filesystems that support them.
    CIFS_XATTR y
    CIFS_POSIX y

    ${extraConfig}
  '';
in

import ./generic.nix (rec {
  version = "2.6.15.7";
  postBuild = "make $makeFlags $kernelTarget";

  src = fetchurl {
    url = "ftp://ftp.kernel.org/pub/linux/kernel/v2.6/linux-${version}.tar.bz2";
      sha256 = "43e0c251924324749b06464512532c3002d6294520faabdba5b3aea4e840b48b";
  };

  config = configWithPlatform stdenv.platform;
  configCross = configWithPlatform stdenv.cross.platform;
}

// removeAttrs args ["extraConfig"]
)