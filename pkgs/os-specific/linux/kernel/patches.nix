{ stdenv, fetchurl }:

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

  grsecPatch = { grversion ? "3.1", kversion, revision, branch, sha256 }:
    { name = "grsecurity-${grversion}-${kversion}";
      inherit grversion kversion revision;
      patch = fetchurl {
        url = "https://github.com/slashbeast/grsecurity-scrape/blob/master/${branch}/grsecurity-${grversion}-${kversion}-${revision}.patch?raw=true";
        inherit sha256;
      };
      features.grsecurity = true;
    };

in

rec {

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

  ubuntu_fan =
    { name = "ubuntu-fan";
      patch = ./ubuntu-fan-3.patch;
    };

  ubuntu_fan_4 =
    { name = "ubuntu-fan";
      patch = ./ubuntu-fan-4.patch;
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

  grsecurity_stable = grsecPatch
    { kversion  = "3.14.51";
      revision  = "201508181951";
      branch    = "stable";
      sha256    = "1sp1gwa7ahzflq7ayb51bg52abrn5zx1hb3pff3axpjqq7vfai6f";
    };

  grsecurity_unstable = grsecPatch
    { kversion  = "4.4.2";
      revision  = "201602182048";
      branch    = "test";
      sha256    = "0dm0nzzja6ynzdz2k5h0ckys7flw307i3w0k1lwjxfj80civ73wr";
    };

  grsec_fix_path =
    { name = "grsec-fix-path";
      patch = ./grsec-path.patch;
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
}
