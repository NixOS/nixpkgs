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
    version = "3.0";
    utilRev = "cabe3601001ab3838215116c32715c9de9412e62";
    utilHash = "7fc6cfe1e69a0b2438eaee056e15d42a2d6be396a637fcfb1b89858fcecc832f";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "517b27621cdfb793959acac849dae9888338526a";
      sha256 = "8085200ac78d0c1e082d4c721a09f4a4c1d96ae86e307075836d09c3e7d502df";
    };
    features.aufsBase = true;
    features.aufs3 = true;
  };

  aufs3_1 = rec {
    name = "aufs3.1";
    version = "3.1";
    utilRev = "cabe3601001ab3838215116c32715c9de9412e62";
    utilHash = "7fc6cfe1e69a0b2438eaee056e15d42a2d6be396a637fcfb1b89858fcecc832f";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "7386b57432ec5e73632a5375804239b02b6c00f0";
      sha256 = "af4e9ad890e1b72d14170c97d8ead53291f09e275db600932724e6181530be2d";
    };
    features.aufsBase = true;
    features.aufs3 = true;
  };

  aufs3_2 = rec {
    name = "aufs3.2";
    version = "3.2";
    utilRev = "a953b0218667e06b722f4c41df29edacd8dc8e1f";
    utilHash = "28ac4c1a07b2c30fb61a6facc9cedcf67b14f303baedf1b121aeb6293ea49eb4";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "9c4bbeb58f0ecc235ea820ae320efa2c0006e033";
      sha256 = "5363a7f5fbadaef9457e743a5781f2525332c4bbb91693ca2596ab2d8f7860ea";
    };
    features.aufsBase = true;
    features.aufs3 = true;
  };

  aufs3_3 = rec {
    name = "aufs3.3";
    version = "3.3";
    utilRev = "91af15f977d12e02165759620005f6ce1a4d7602";
    utilHash = "dda4df89828dcf0e4012d88b4aa3eda8c30af69d6530ff5fedc2411de872c996";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "91c3d8c80172db05575ee82c931f3541947a6aff";
      sha256 = "8fe54993b6a7a290649c193aab5a4f7f2dcecaedb5422d951f898d03753b83fb";
    };
    features.aufsBase = true;
    features.aufs3 = true;
  };

  aufs3_4 = rec {
    name = "aufs3.4";
    version = "3.4";
    utilRev = "91af15f977d12e02165759620005f6ce1a4d7602";
    utilHash = "dda4df89828dcf0e4012d88b4aa3eda8c30af69d6530ff5fedc2411de872c996";
    patch = makeAufs3StandalonePatch {
      inherit version;
      rev = "a5f7df8e59d57d6d9d749d49adc7e5a37ce2e342";
      sha256 = "20a8f113bb654f92231726de8177eb51d7be1b900fd42c2b5f48726a7d5d3ce6";
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
