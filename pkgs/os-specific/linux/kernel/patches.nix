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
    version = "3.0.20120827";
    utilRev = "91af15f977d12e02165759620005f6ce1a4d7602";
    utilHash = "dda4df89828dcf0e4012d88b4aa3eda8c30af69d6530ff5fedc2411de872c996";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "4bd8efe495832ec43c26cb31ddcab3bae56485da";
      sha256 = "496113f0eae1a24ae0c1998d1c73fc7c13961579c8e694b3651a8080eae7b74e";
    };
    features.aufsBase = true;
    features.aufs3 = true;
  };

  aufs3_1 = rec {
    name = "aufs3.1";
    version = "3.1.20120827";
    utilRev = "91af15f977d12e02165759620005f6ce1a4d7602";
    utilHash = "dda4df89828dcf0e4012d88b4aa3eda8c30af69d6530ff5fedc2411de872c996";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "9be47f1ff7c86976b0baa7847f22d75983e53922";
      sha256 = "0cd239b9aad396750a26a5cd7b0d54146f21db63fb13d3fa03c4f73b7ebce77e";
    };
    features.aufsBase = true;
    features.aufs3 = true;
  };

  aufs3_2 = rec {
    name = "aufs3.2";
    version = "3.2.20120827";
    utilRev = "91af15f977d12e02165759620005f6ce1a4d7602";
    utilHash = "dda4df89828dcf0e4012d88b4aa3eda8c30af69d6530ff5fedc2411de872c996";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "267cb1138b4724ee028ec64ace556abdf993c9f4";
      sha256 = "61f69264806cf06a05548166e2bc8fd121de9a3e524385f725d76abab22b8a0d";
    };
    features.aufsBase = true;
    features.aufs3 = true;
  };

  aufs3_3 = rec {
    name = "aufs3.3";
    version = "3.3.20120827";
    utilRev = "91af15f977d12e02165759620005f6ce1a4d7602";
    utilHash = "dda4df89828dcf0e4012d88b4aa3eda8c30af69d6530ff5fedc2411de872c996";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "ef302b8a8a2862b622cf4826d08b1e076ee6acb7";
      sha256 = "7f78783685cc3e4eb825cd5dd8dabc82bb16c275493a850e8b7955ac69048d98";
    };
    features.aufsBase = true;
    features.aufs3 = true;
  };

  aufs3_4 = rec {
    name = "aufs3.4";
    version = "3.4.20120827";
    utilRev = "91af15f977d12e02165759620005f6ce1a4d7602";
    utilHash = "dda4df89828dcf0e4012d88b4aa3eda8c30af69d6530ff5fedc2411de872c996";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "79d8207b22c38420757adf7eec86ee2dcec7443c";
      sha256 = "bc148aa251c6e63edca70c516c0548dc9b3e48653039df4cf693aa2bcc1b9bb0";
    };
    features.aufsBase = true;
    features.aufs3 = true;
  };

  aufs3_5 = rec {
    name = "aufs3.5";
    version = "3.5.20120827";
    utilRev = "91af15f977d12e02165759620005f6ce1a4d7602";
    utilHash = "dda4df89828dcf0e4012d88b4aa3eda8c30af69d6530ff5fedc2411de872c996";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "18e455787597579fe144cdb2f18aa6a0a32c46a4";
      sha256 = "9649a4cb00e41e2b2e3aa57c3869c33faf90ecbd845a3ac0119922655e80a030";
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

  no_xsave =
    { name = "no-xsave";
      patch = ./no-xsave.patch;
      features.noXsave = true;
    };

  dell_rfkill =
    { name = "dell-rfkill";
      patch = ./dell-rfkill.patch;
    };

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
