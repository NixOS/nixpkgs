{ stdenv, fetchurl, pkgs }:

let

  makeTuxonicePatch = { version, kernelVersion, sha256,
    url ? "http://tuxonice.nigelcunningham.com.au/downloads/all/tuxonice-for-linux-${kernelVersion}-${version}.patch.bz2" }:
    { name = "tuxonice-${kernelVersion}";
      patch = stdenv.mkDerivation {
        name = "tuxonice-${version}-for-${kernelVersion}.patch";
        src = fetchurl {
          inherit url sha256;
        };
        phases = [ "installPhase" ];
        installPhase = ''
          source $stdenv/setup
          bunzip2 -c $src > $out
        '';
      };
    };

  grsecPatch = { grversion ? "3.1", kernel, patches, kversion, revision, branch ? "test", sha256 }:
    assert kversion == kernel.version;
    { name = "grsecurity-${grversion}-${kversion}";
      inherit grversion kernel patches kversion revision;
      patch = fetchurl {
        url = "https://grsecurity.net/${branch}/grsecurity-${grversion}-${kversion}-${revision}.patch";
        inherit sha256;
      };
      features.grsecurity = true;
    };

in

rec {

  link_lguest =
    { name = "gcc5-link-lguest";
      patch = ./gcc5-link-lguest.patch;
    };

  link_apm =
    { name = "gcc5-link-apm";
      patch = ./gcc5-link-apm.patch;
    };

  bridge_stp_helper =
    { name = "bridge-stp-helper";
      patch = ./bridge-stp-helper.patch;
    };

  no_xsave =
    { name = "no-xsave";
      patch = ./no-xsave.patch;
      features.noXsave = true;
    };

  mips_fpureg_emu =
    { name = "mips-fpureg-emulation";
      patch = ./mips-fpureg-emulation.patch;
    };

  mips_fpu_sigill =
    { name = "mips-fpu-sigill";
      patch = ./mips-fpu-sigill.patch;
    };

  mips_ext3_n32 =
    { name = "mips-ext3-n32";
      patch = ./mips-ext3-n32.patch;
    };

  ubuntu_fan_4_4 =
    { name = "ubuntu-fan";
      patch = ./ubuntu-fan-4.4.patch;
    };

  ubuntu_unprivileged_overlayfs =
    { name = "ubuntu-unprivileged-overlayfs";
      patch = ./ubuntu-unprivileged-overlayfs.patch;
    };

  tuxonice_3_10 = makeTuxonicePatch {
    version = "2013-11-07";
    kernelVersion = "3.10.18";
    sha256 = "00b1rqgd4yr206dxp4mcymr56ymbjcjfa4m82pxw73khj032qw3j";
  };

  grsecurity_3_14 = grsecPatch
    { kernel    = pkgs.grsecurity_base_linux_3_14;
      patches   = [ grsecurity_fix_path_3_14 ];
      kversion  = "3.14.51";
      revision  = "201508181951";
      branch    = "stable";
      sha256    = "1sp1gwa7ahzflq7ayb51bg52abrn5zx1hb3pff3axpjqq7vfai6f";
    };

  grsecurity_4_4 = grsecPatch
    { kernel    = pkgs.grsecurity_base_linux_4_4;
      patches   = [ grsecurity_fix_path_4_4 ];
      kversion  = "4.4.5";
      revision  = "201603131305";
      sha256    = "04k4nhshl6r5n41ha5620s7cd70dmmmvyf9mnn5359jr1720kxpf";
    };

  grsecurity_4_5 = grsecPatch
    { kernel    = pkgs.grsecurity_base_linux_4_5;
      patches   = [ grsecurity_fix_path_4_5 ];
      kversion  = "4.5.3";
      revision  = "201605060852";
      sha256    = "1yg5fp60nay2cvnpxnx29995wk04r995y9030dwkgk3xpxifr6z1";
    };

  grsecurity_latest = grsecurity_4_5;

  grsecurity_fix_path_3_14 =
    { name = "grsecurity-fix-path-3.14";
      patch = ./grsecurity-path-3.14.patch;
    };

  grsecurity_fix_path_4_4 =
    { name = "grsecurity-fix-path-4.4";
      patch = ./grsecurity-path-4.4.patch;
    };

  grsecurity_fix_path_4_5 =
    { name = "grsecurity-fix-path-4.5";
      patch = ./grsecurity-path-4.5.patch;
    };

  crc_regression =
    { name = "crc-backport-regression";
      patch = ./crc-regression.patch;
    };

  genksyms_fix_segfault =
    { name = "genksyms-fix-segfault";
      patch = ./genksyms-fix-segfault.patch;
    };


  chromiumos_Kconfig_fix_entries_3_14 =
    { name = "Kconfig_fix_entries_3_14";
      patch = ./chromiumos-patches/fix-double-Kconfig-entry-3.14.patch;
    };

  chromiumos_Kconfig_fix_entries_3_18 =
    { name = "Kconfig_fix_entries_3_18";
      patch = ./chromiumos-patches/fix-double-Kconfig-entry-3.18.patch;
    };

  chromiumos_no_link_restrictions =
    { name = "chromium-no-link-restrictions";
      patch = ./chromiumos-patches/no-link-restrictions.patch;
    };

  chromiumos_mfd_fix_dependency =
    { name = "mfd_fix_dependency";
      patch = ./chromiumos-patches/mfd-fix-dependency.patch;
    };
  qat_common_Makefile =
    { name = "qat_common_Makefile";
      patch = ./qat_common_Makefile.patch;
    };
}
