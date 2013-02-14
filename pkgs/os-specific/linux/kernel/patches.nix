{ stdenv, fetchurl, fetchgit }:

let

  fbcondecorConfig =
    ''
      FB_CON_DECOR y

      # fbcondecor is picky about some other settings.
      FB y
      FB_TILEBLITTING n
      FB_MATROX n
      FB_S3 n
      FB_VT8623 n
      FB_ARK n
      FB_CFB_FILLRECT y
      FB_CFB_COPYAREA y
      FB_CFB_IMAGEBLIT y
      FB_VESA y
      FRAMEBUFFER_CONSOLE y
    '';

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

in

rec {

  sec_perm_2_6_24 =
    { name = "sec_perm-2.6.24";
      patch = ./sec_perm-2.6.24.patch;
      features.secPermPatch = true;
    };

  fbcondecor_2_6_31 =
    { name = "fbcondecor-0.9.6-2.6.31.2";
      patch = fetchurl {
        url = http://dev.gentoo.org/~spock/projects/fbcondecor/archive/fbcondecor-0.9.6-2.6.31.2.patch;
        sha256 = "1avk0yn0y2qbpsxf31r6d14y4a1mand01r4k4i71yfxvpqcgxka9";
      };
      extraConfig = fbcondecorConfig;
      features.fbConDecor = true;
    };

  fbcondecor_2_6_35 =
    rec {
      name = "fbcondecor-0.9.6-2.6.35-rc4";
      patch = fetchurl {
        url = "http://dev.gentoo.org/~spock/projects/fbcondecor/archive/${name}.patch";
        sha256 = "0dlks1arr3b3hlmw9k1a1swji2x655why61sa0aahm62faibsg1r";
      };
      extraConfig = fbcondecorConfig;
      features.fbConDecor = true;
    };

  aufs2_2_6_32 =
    { # From http://git.c3sl.ufpr.br/gitweb?p=aufs/aufs2-standalone.git;a=tree;h=refs/heads/aufs2-32;hb=aufs2-32
      # Note that this merely the patch needed to build AUFS2 as a
      # standalone package.
      name = "aufs2";
      patch = ./aufs2.patch;
      features.aufsBase = true;
      features.aufs2 = true;
    };

  aufs2_2_6_35 =
    { # From http://git.c3sl.ufpr.br/gitweb?p=aufs/aufs2-standalone.git;a=tree;h=refs/heads/aufs2-35;hb=aufs2-35
      # Note that this merely the patch needed to build AUFS2 as a
      # standalone package.
      name = "aufs2";
      patch = ./aufs2-35.patch;
      features.aufsBase = true;
      features.aufs2 = true;
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

  aufs3_5 = rec {
    name = "aufs3.5";
    version = "3.5.20121210";
    utilRev = "91af15f977d12e02165759620005f6ce1a4d7602";
    utilHash = "dda4df89828dcf0e4012d88b4aa3eda8c30af69d6530ff5fedc2411de872c996";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "1658e9080c0e49f38feee5027cf0d32940a661ca";
      sha256 = "4577fe1dd34299520155767a7c42697d41aabc0055ae8b1e448449b8c24a1044";
    };
    features.aufsBase = true;
    features.aufs3 = true;
  };

  aufs3_6 = rec {
    name = "aufs3.6";
    version = "3.6.20121210";
    utilRev = "91af15f977d12e02165759620005f6ce1a4d7602";
    utilHash = "dda4df89828dcf0e4012d88b4aa3eda8c30af69d6530ff5fedc2411de872c996";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "f541ebfd88df0f4e6f9daf55053282e4f52cc4d9";
      sha256 = "4d615a5f3c14a6a7c49bc6d65e78a2cdb89321cbd8a53f87cc8fe9edda382c3a";
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
  cifs_timeout_2_6_15 =
    { name = "cifs-timeout";
      patch = ./cifs-timeout-2.6.15.patch;
      features.cifsTimeout = true;
    };

  cifs_timeout_2_6_29 =
    { name = "cifs-timeout";
      patch = ./cifs-timeout-2.6.29.patch;
      features.cifsTimeout = true;
    };

  cifs_timeout_2_6_35 =
    { name = "cifs-timeout";
      patch = ./cifs-timeout-2.6.35.patch;
      features.cifsTimeout = true;
    };

  cifs_timeout_2_6_38 =
    { name = "cifs-timeout";
      patch = ./cifs-timeout-2.6.38.patch;
      features.cifsTimeout = true;
    };

  cifs_timeout_3_5_7 =
    { name = "cifs-timeout";
      patch = ./cifs-timeout-3.5.7.patch;
      features.cifsTimeout = true;
    };

  no_xsave =
    { name = "no-xsave";
      patch = ./no-xsave.patch;
      features.noXsave = true;
    };

  dell_rfkill =
    { name = "dell-rfkill";
      patch = ./dell-rfkill.patch;
    };

  # seems no longer necessary on 3.6
  perf3_5 =
    { name = "perf-3.5";
      patch = ./perf-3.5.patch;
    };

  sheevaplug_modules_2_6_35 =
    { name = "sheevaplug_modules-2.6.35";
      patch = ./sheevaplug_modules-2.6.35.patch;
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
