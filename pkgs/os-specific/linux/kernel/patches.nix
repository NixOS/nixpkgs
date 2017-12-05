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
in

rec {

  bridge_stp_helper =
    { name = "bridge-stp-helper";
      patch = ./bridge-stp-helper.patch;
    };

  p9_fixes =
    { name = "p9-fixes";
      patch = ./p9-fixes.patch;
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

  grsecurity_testing = throw ''
    Upstream has ceased free support for grsecurity/PaX.

    See https://grsecurity.net/passing_the_baton.php
    and https://grsecurity.net/passing_the_baton_faq.php
    for more information.
  '';

  genksyms_fix_segfault =
    { name = "genksyms-fix-segfault";
      patch = ./genksyms-fix-segfault.patch;
    };

  chromiumos_Kconfig_fix_entries_3_18 =
    { name = "Kconfig_fix_entries_3_18";
      patch = ./chromiumos-patches/fix-double-Kconfig-entry-3.18.patch;
    };

  chromiumos_no_link_restrictions =
    { name = "chromium-no-link-restrictions";
      patch = ./chromiumos-patches/no-link-restrictions.patch;
    };

  cpu-cgroup-v2 = import ./cpu-cgroup-v2-patches;

  DCCP_double_free_vulnerability_CVE-2017-6074 = rec
    { name = "DCCP_double_free_vulnerability_CVE-2017-6074.patch";
      patch = fetchpatch {
        inherit name;
        url = "https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/?id=5edabca9d4cff7f1f2b68f0bac55ef99d9798ba4";
        sha256 = "10dmv3d3gj8rvj9h40js4jh8xbr5wyaqiy0kd819mya441mj8ll2";
      };
    };

  tag_hardened = rec {
    name = "tag-hardened";
    patch = ./tag-hardened.patch;
  };
}
