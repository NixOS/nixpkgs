{ stdenv, fetchurl, fetchgit, apparmor }:

let

  makeTuxonicePatch = { version, kernelVersion, sha256,
    url ? "http://tuxonice.net/files/tuxonice-${version}-for-${kernelVersion}.patch.bz2" }:
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

  makeAufs3StandalonePatch = {version, rev, sha256}:

    stdenv.mkDerivation {
      name = "aufs3-standalone-${version}.patch";

      src = fetchgit {
        url = git://aufs.git.sourceforge.net/gitroot/aufs/aufs3-standalone.git;
        inherit sha256 rev;
      };

      phases = [ "unpackPhase" "installPhase" ];

      # Instructions from http://aufs.git.sourceforge.net/git/gitweb.cgi?p=aufs/aufs3-standalone.git;a=blob;f=Documentation/filesystems/aufs/README;h=b8cf077635b323d1b454266366f05f476bbd09cb;hb=1067b9d8d64d23c70d905c9cd3c90a669e39c4d4
      installPhase = ''
        cat aufs3-base.patch aufs3-proc_map.patch aufs3-standalone.patch > $out
      '';
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

  apparmor_3_2 = {
    features.apparmor = true;
    patch = makeAppArmorPatch { version = "3.2"; inherit apparmor; };
  };

  sec_perm_2_6_24 =
    { name = "sec_perm-2.6.24";
      patch = ./sec_perm-2.6.24.patch;
      features.secPermPatch = true;
    };

  aufs3_0 = rec {
    name = "aufs3.0";
    version = "3.0.20121210";
    utilRev = "91af15f977d12e02165759620005f6ce1a4d7602";
    utilHash = "dda4df89828dcf0e4012d88b4aa3eda8c30af69d6530ff5fedc2411de872c996";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "0627c706d69778f5c74be982f28c746153b8cdf7";
      sha256 = "7008ff64f5adc2b3a30fcbb090bcbfaac61b778af38493b6144fc7d768a6514d";
    };
    features.aufsBase = true;
    features.aufs3 = true;
  };

  aufs3_2 = rec {
    name = "aufs3.2";
    version = "3.2.20121210";
    utilRev = "91af15f977d12e02165759620005f6ce1a4d7602";
    utilHash = "dda4df89828dcf0e4012d88b4aa3eda8c30af69d6530ff5fedc2411de872c996";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "0bf50c3b82f98e2ddc4c9ba0657f28ebfa8d15cb";
      sha256 = "bc4b65cb77c62744db251da98488fdf4962f14a144c045cea6cbbbd42718ff89";
    };
    features.aufsBase = true;
    features.aufs3 = true;
  };

  aufs3_4 = rec {
    name = "aufs3.4";
    version = "3.4.20121210";
    utilRev = "91af15f977d12e02165759620005f6ce1a4d7602";
    utilHash = "dda4df89828dcf0e4012d88b4aa3eda8c30af69d6530ff5fedc2411de872c996";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "2faacd9baffb37df3b9062cc554353eebe68df1e";
      sha256 = "3ecf97468f5e85970d9fd2bfc61e38c7f5ae2c6dde0045d5a17de085c411d452";
    };
    features.aufsBase = true;
    features.aufs3 = true;
  };

  # not officially released yet, but 3.x seems to work fine
  aufs3_7 = rec {
    name = "aufs3.7";
    version = "3.x.20121210";
    utilRev = "91af15f977d12e02165759620005f6ce1a4d7602";
    utilHash = "dda4df89828dcf0e4012d88b4aa3eda8c30af69d6530ff5fedc2411de872c996";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "8d24d728c7eb54dd624bccd8e87afa826670142c";
      sha256 = "02dcb46e02b2a6b90c1601b5747614276074488c9308625c3a52ab74cad997a5";
    };
    features.aufsBase = true;
    features.aufs3 = true;
  };

  # Increase the timeout on CIFS requests from 15 to 120 seconds to
  # make CIFS more resilient to high load on the CIFS server.
  cifs_timeout_2_6_38 =
    { name = "cifs-timeout";
      patch = ./cifs-timeout-2.6.38.patch;
      features.cifsTimeout = true;
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

  guruplug_defconfig =
    { # Default configuration for the GuruPlug.  From
      # <http://www.openplug.org/plugwiki/images/c/c6/Guruplug-patchset-2.6.33.2.tar.bz2>.
      name = "guruplug-defconfig";
      patch = ./guruplug-defconfig.patch;
    };

  guruplug_arch_number =
    { # Hack to match the `arch_number' of the U-Boot that ships with the
      # GuruPlug.  This is only needed when using this specific U-Boot
      # binary.  See
      # <http://www.plugcomputer.org/plugwiki/index.php/Compiling_Linux_Kernel_for_the_Plug_Computer>.
      name = "guruplug-arch-number";
      patch = ./guruplug-mach-type.patch;
    };
}
