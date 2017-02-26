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

  grsecPatch = { grbranch ? "test", grver ? "3.1", kver, grrev, sha512 }: rec {
    name = "grsecurity-${grver}-${kver}-${grrev}";

    # Pass these along to allow the caller to determine compatibility
    inherit grver kver grrev;

    patch = fetchurl {
      urls = [
        "https://grsecurity.net/${grbranch}/${name}.patch"
        # When updating versions/hashes, ALWAYS use the official
        # version; we use this mirror only because upstream removes
        # source files immediately upon releasing a new version ...
        "https://raw.githubusercontent.com/slashbeast/grsecurity-scrape/master/${grbranch}/${kver}/${name}.patch"
      ];
      inherit sha512;
    };

    features.grsecurity = true;
  };
in

rec {

  multithreaded_rsapubkey =
    {
      name = "multithreaded-rsapubkey-asn1.patch";
      patch = ./multithreaded-rsapubkey-asn1.patch;
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

  grsecurity_testing = grsecPatch
    { kver   = "4.9.13";
      grrev  = "201702261126";
      sha512 = "18snigndkyw372mp65v3sp9cpz8w4n3d3lzls50a3gl1qgnpp65g0vbf7vsm3spr9a5p5f17n7hl7lxgm0pqnjcgg0xr5ghkwx20z6b";
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

  lguest_entry-linkage =
    { name = "lguest-asmlinkage.patch";
      patch = fetchpatch {
        url = "https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git"
            + "/patch/drivers/lguest/x86/core.c?id=cdd77e87eae52";
        sha256 = "04xlx6al10cw039av6jkby7gx64zayj8m1k9iza40sw0fydcfqhc";
      };
    };

  packet_fix_race_condition_CVE_2016_8655 =
    { name = "packet_fix_race_condition_CVE_2016_8655.patch";
      patch = fetchpatch {
        url = "https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/?id=84ac7260236a49c79eede91617700174c2c19b0c";
        sha256 = "19viqjjgq8j8jiz5yhgmzwhqvhwv175q645qdazd1k69d25nv2ki";
      };
    };

  panic_on_icmp6_frag_CVE_2016_9919 = rec
    { name = "panic_on_icmp6_frag_CVE_2016_9919.patch";
      patch = fetchpatch {
        inherit name;
        url = "https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/?id=79dc7e3f1cd323be4c81aa1a94faa1b3ed987fb2";
        sha256 = "0mps33r4mnwiy0bmgrzgqkrk59yya17v6kzpv9024g4xlz61rk8p";
      };
    };

  DCCP_double_free_vulnerability_CVE-2017-6074 = rec
    { name = "DCCP_double_free_vulnerability_CVE-2017-6074.patch";
      patch = fetchpatch {
        inherit name;
        url = "https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/?id=5edabca9d4cff7f1f2b68f0bac55ef99d9798ba4";
        sha256 = "10dmv3d3gj8rvj9h40js4jh8xbr5wyaqiy0kd819mya441mj8ll2";
      };
    };
}
