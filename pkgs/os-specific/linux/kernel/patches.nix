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

  makeAppArmorPatch = {apparmor, version}:
    stdenv.mkDerivation {
      name = "apparmor-${version}.patch";
      phases = ["installPhase"];
      installPhase = ''
        cat ${apparmor}/kernel-patches/${version}/* > $out
      '';
    };
in

rec {

  apparmor_3_2 = rec {
    version = "3.2";
    name = "apparmor-${version}";
    patch = makeAppArmorPatch { inherit apparmor version; };
    features.apparmor = true;
  };

  apparmor_3_4 = rec {
    version = "3.4";
    name = "apparmor-${version}";
    patch = makeAppArmorPatch { inherit apparmor version; };
    features.apparmor = true;
  };

  sec_perm_2_6_24 =
    { name = "sec_perm-2.6.24";
      patch = ./sec_perm-2.6.24.patch;
      features.secPermPatch = true;
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

  tuxonice_3_10 = makeTuxonicePatch {
    version = "2013-11-07";
    kernelVersion = "3.10.18";
    sha256 = "00b1rqgd4yr206dxp4mcymr56ymbjcjfa4m82pxw73khj032qw3j";
  };


  grsecurity_3_0_3_2_54 =
    { name = "grsecurity-3.0-3.2.54";
      patch = fetchurl {
        url = https://grsecurity.net/stable/grsecurity-3.0-3.2.54-201402062221.patch;
        sha256 = "14x887xibl7d50a1pxmi0snnwcnh27z8bnidhxg2xfasxxp248m5";
      };
      features.grsecurity = true;
      # The grsec kernel patch seems to include the apparmor patches as of 3.0-3.2.54
      features.apparmor = true;
    };

  grsecurity_3_0_3_13_2 =
    { name = "grsecurity-3.0-3.13.2";
      patch = fetchurl {
        url = https://grsecurity.net/test/grsecurity-3.0-3.13.2-201402062224.patch;
        sha256 = "0w42d76bv7yzpr23bicsadf64csbmq988kmpzxg4yv5qwzhhbyh7";
      };
      features.grsecurity = true;
      # The grsec kernel patch seems to include the apparmor patches as of 3.0-3.13.2
      features.apparmor = true;
    };

  grsec_path =
    { name = "grsec-path";
      patch = ./grsec-path.patch;
    };
}
