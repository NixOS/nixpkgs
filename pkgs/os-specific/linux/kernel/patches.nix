{ stdenv, fetchurl, fetchgit, apparmor }:

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

  grsecPatch = { grversion ? "3.0", kversion, revision, branch, sha256 }:
    { name = "grsecurity-${grversion}-${kversion}";
      inherit grversion kversion revision;
      patch = fetchurl {
        url = "http://grsecurity.net/${branch}/grsecurity-${grversion}-${kversion}-${revision}.patch";
        inherit sha256;
      };
      features.grsecurity = true;
    };

in

rec {

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

  tuxonice_3_10 = makeTuxonicePatch {
    version = "2013-11-07";
    kernelVersion = "3.10.18";
    sha256 = "00b1rqgd4yr206dxp4mcymr56ymbjcjfa4m82pxw73khj032qw3j";
  };

  grsecurity_stable = grsecPatch
    { kversion  = "3.2.58";
      revision  = "201405112002";
      branch    = "stable";
      sha256    = "107jbgl1lz6blrk5rxm10jjhbywav9s56bs7zfs3m1618bff7p7v";
    };

  grsecurity_vserver = grsecPatch
    { kversion  = "3.2.58";
      revision  = "vs2.3.2.16-201405112004";
      branch    = "vserver";
      sha256    = "0xi7c1q0qsvdvs9vw3iclfz8ykjf56cc9wds6419z1lcgcaykb9w";
    };

  grsecurity_unstable = grsecPatch
    { kversion  = "3.14.4";
      revision  = "201405141623";
      branch    = "test";
      sha256    = "0k9f3n1hxxqa2l10mjk7hy7w9p0mmiqv6s6cbiji2hyvakm5s7p4";
    };

  grsec_fix_path =
    { name = "grsec-fix-path";
      patch = ./grsec-path.patch;
    };
}
