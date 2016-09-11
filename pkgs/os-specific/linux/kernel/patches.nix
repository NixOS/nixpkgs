{ stdenv, fetchurl, fetchpatch, pkgs }:

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

  grsecPatch = { grbranch ? "test", grver ? "3.1", kver, grrev, sha256 }: rec {
    name = "grsecurity-${grver}-${kver}-${grrev}";

    # Pass these along to allow the caller to determine compatibility
    inherit grver kver grrev;

    patch = fetchurl {
      # When updating versions/hashes, ALWAYS use the official version; we use
      # this mirror only because upstream removes sources files immediately upon
      # releasing a new version ...
      url = "https://raw.githubusercontent.com/slashbeast/grsecurity-scrape/master/${grbranch}/${name}.patch";
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

  modinst_arg_list_too_long =
    { name = "modinst-arglist-too-long";
      patch = ./modinst-arg-list-too-long.patch;
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

  grsecurity_3_14 = throw "grsecurity stable is no longer supported";

  grsecurity_4_4 = throw "grsecurity stable is no longer supported";

  grsecurity_testing = grsecPatch
    { kver   = "4.7.3";
      grrev  = "201609072139";
      sha256 = "0c70nfsa1bk07z6sivy645d9w0qkq23pwpwdm28160kfy7dampyh";
    };

  # This patch relaxes grsec constraints on the location of usermode helpers,
  # e.g., modprobe, to allow calling into the Nix store.
  grsecurity_nixos_kmod =
    {
      name  = "grsecurity-nixos-kmod";
      patch = ./grsecurity-nixos-kmod.patch;
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

  hiddev_CVE_2016_5829 =
    { name = "hiddev_CVE_2016_5829";
      patch = fetchpatch {
        url = "https://sources.debian.net/data/main/l/linux/4.6.3-1/debian/patches/bugfix/all/HID-hiddev-validate-num_values-for-HIDIOCGUSAGES-HID.patch";
        sha256 = "14rm1qr87p7a5prz8g5fwbpxzdp3ighj095x8rvhm8csm20wspyy";
      };
    };

  cpu-cgroup-v2 = import ./cpu-cgroup-v2-patches;
}
