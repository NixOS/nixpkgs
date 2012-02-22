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

  fbcondecor_2_6_25 =
    { name = "fbcondecor-0.9.4-2.6.25-rc6";
      patch = fetchurl {
        url = http://dev.gentoo.org/~spock/projects/fbcondecor/archive/fbcondecor-0.9.4-2.6.25-rc6.patch;
        sha256 = "1wm94n7f0qyb8xvafip15r158z5pzw7zb7q8hrgddb092c6ibmq8";
      };
      extraConfig = fbcondecorConfig;
      features.fbConDecor = true;
    };

  fbcondecor_2_6_27 =
    { name = "fbcondecor-0.9.4-2.6.27";
      patch = fetchurl {
        url = http://dev.gentoo.org/~spock/projects/fbcondecor/archive/fbcondecor-0.9.4-2.6.27.patch;
        sha256 = "170l9l5fvbgjrr4klqcwbgjg4kwvrrhjpmgbfpqj0scq0s4q4vk6";
      };
      extraConfig = fbcondecorConfig;
      features.fbConDecor = true;
    };

  fbcondecor_2_6_28 =
    { name = "fbcondecor-0.9.5-2.6.28";
      patch = fetchurl {
        url = http://dev.gentoo.org/~spock/projects/fbcondecor/archive/fbcondecor-0.9.5-2.6.28.patch;
        sha256 = "105q2dwrwi863r7nhlrvljim37aqv67mjc3lgg529jzqgny3fjds";
      };
      extraConfig = fbcondecorConfig;
      features.fbConDecor = true;
    };

  fbcondecor_2_6_29 =
    { name = "fbcondecor-0.9.6-2.6.29.2";
      patch = fetchurl {
        url = http://dev.gentoo.org/~spock/projects/fbcondecor/archive/fbcondecor-0.9.6-2.6.29.2.patch;
        sha256 = "1yppvji13sgnql62h4wmskzl9l198pp1pbixpbymji7mr4a0ylx1";
      };
      extraConfig = fbcondecorConfig;
      features.fbConDecor = true;
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

  fbcondecor_2_6_33 =
    { name = "fbcondecor-0.9.6-2.6.33-rc7";
      patch = fetchurl {
        url = http://dev.gentoo.org/~spock/projects/fbcondecor/archive/fbcondecor-0.9.6-2.6.33-rc7.patch;
        sha256 = "1v9lg3bgva0xry0s09drpw3n139s8hln8slayaf6i26vg4l4xdz6";
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

  fbcondecor_2_6_37 =
    rec {
      name = "fbcondecor-0.9.6-2.6.37";
      patch = fetchurl {
        url = "http://dev.gentoo.org/~spock/projects/fbcondecor/archive/${name}.patch";
        sha256 = "1yap9q6mp15jhsysry4x17cpm5dj35g8l2d0p0vn1xq25x3jfkqk";
      };
      extraConfig = fbcondecorConfig;
      features.fbConDecor = true;
    };

  fbcondecor_2_6_38 =
    rec {
      name = "fbcondecor-0.9.6-2.6.38";
      patch = fetchurl {
        url = "http://dev.gentoo.org/~spock/projects/fbcondecor/archive/${name}.patch";
        sha256 = "1l8xqf5z227m5ay6azqba1qw10y26a4cwfhzzapzmmwq1bpr8mlw";
      };
      extraConfig = fbcondecorConfig;
      features.fbConDecor = true;
    };

  # From http://patchwork.kernel.org/patch/19495/
  ext4_softlockups_2_6_28 =
    { name = "ext4-softlockups-fix";
      patch = fetchurl {
        url = http://patchwork.kernel.org/patch/19495/raw;
        sha256 = "0vqcj9qs7jajlvmwm97z8cljr4vb277aqhsjqrakbxfdiwlhrzzf";
      };
    };

  gcov_2_6_28 =
    { name = "gcov";
      patch = fetchurl {
        url = http://buildfarm.st.ewi.tudelft.nl/~eelco/dist/linux-2.6.28-gcov.patch;
        sha256 = "0ck9misa3pgh3vzyb7714ibf7ix7piyg5dvfa9r42v15scjqiyny";
      };
      extraConfig =
        ''
          GCOV_PROFILE y
          GCOV_ALL y
          GCOV_PROC m
          GCOV_HAMMER n
        '';
    };

  tracehook_2_6_32 =
    { # From <http://userweb.kernel.org/~frob/utrace/>.
      name = "tracehook";
      patch = fetchurl {
        url = http://userweb.kernel.org/~frob/utrace/2.6.32/tracehook.patch;
        sha256 = "1y009p8dyqknbjm8ryb495jqmvl372gfhswdn167xh2g1f24xqv8";
      };
    };

  utrace_2_6_32 =
    { # From <http://userweb.kernel.org/~frob/utrace/>, depends on the
      # `tracehook' patch above.
      # See also <http://sourceware.org/systemtap/wiki/utrace>.
      name = "utrace";
      patch = fetchurl {
        url = http://userweb.kernel.org/~frob/utrace/2.6.32/utrace.patch;
        sha256 = "0argf19k9f0asiv4l4cnsxm5hw2xx8d794npaln88vwz87sj5nnq";
      };
      extraConfig =
        '' UTRACE y
        '';
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

  aufs2_2_6_33 =
    { # From http://git.c3sl.ufpr.br/gitweb?p=aufs/aufs2-standalone.git;a=tree;h=refs/heads/aufs2-33;hb=aufs2-33
      # Note that this merely the patch needed to build AUFS2 as a
      # standalone package.
      name = "aufs2";
      patch = ./aufs2-33.patch;
      features.aufsBase = true;
      features.aufs2 = true;
    };

  aufs2_2_6_34 =
    { # From http://git.c3sl.ufpr.br/gitweb?p=aufs/aufs2-standalone.git;a=tree;h=refs/heads/aufs2-34;hb=aufs2-34
      # Note that this merely the patch needed to build AUFS2 as a
      # standalone package.
      name = "aufs2";
      patch = ./aufs2-34.patch;
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

  aufs2_2_6_36 =
    { # From http://git.c3sl.ufpr.br/gitweb?p=aufs/aufs2-standalone.git;a=tree;h=refs/heads/aufs2.1-36;hb=aufs2.1-36
      # Note that this merely the patch needed to build AUFS2 as a
      # standalone package.
      name = "aufs2";
      patch = ./aufs2.1-36.patch;
      features.aufsBase = true;
      features.aufs2_1 = true;
    };

  aufs2_1_2_6_37 =
    { # From http://git.c3sl.ufpr.br/gitweb?p=aufs/aufs2-standalone.git;a=tree;h=refs/heads/aufs2.1-37;hb=refs/heads/aufs2.1-37
      # Note that this merely the patch needed to build AUFS2.1 as a
      # standalone package.
      name = "aufs2.1";
      patch = ./aufs2.1-37.patch;
      features.aufsBase = true;
      features.aufs2_1 = true;
    };

  aufs2_1_2_6_38 =
    { # From http://aufs.git.sourceforge.net/git/gitweb.cgi?p=aufs/aufs2-standalone.git;a=tree;h=refs/heads/aufs2.1-38;hb=refs/heads/aufs2.1-38
      # Note that this merely the patch needed to build AUFS2.1 as a
      # standalone package.
      name = "aufs2.1";
      patch = ./aufs2.1-38.patch;
      features.aufsBase = true;
      features.aufs2_1 = true;
    };

  aufs2_1_2_6_39 =
    { # From http://aufs.git.sourceforge.net/git/gitweb.cgi?p=aufs/aufs2-standalone.git;a=tree;h=refs/heads/aufs2.1-39;hb=refs/heads/aufs2.1-39
      # Note that this merely the patch needed to build AUFS2.1 as a
      # standalone package.
      name = "aufs2.1";
      patch = ./aufs2.1-39.patch;
      features.aufsBase = true;
      features.aufs2_1 = true;
    };

  aufs2_1_3_0 =
    { # From http://aufs.git.sourceforge.net/git/gitweb.cgi?p=aufs/aufs2-standalone.git;a=tree;h=ac52a37b0debba539bdfabba101f82b99136b380;hb=ac52a37b0debba539bdfabba101f82b99136b380
      # Note that this merely the patch needed to build AUFS2.1 as a
      # standalone package.
      name = "aufs2.1";
      patch = ./aufs2.1-3.0.patch;
      features.aufsBase = true;
      features.aufs2_1 = true;
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

  # Increase the timeout on CIFS requests from 15 to 120 seconds to
  # make CIFS more resilient to high load on the CIFS server.
  cifs_timeout_2_6_15 =
    { name = "cifs-timeout";
      patch = ./cifs-timeout-2.6.15.patch;
      features.cifsTimeout = true;
    };

  cifs_timeout_2_6_25 =
    { name = "cifs-timeout";
      patch = ./cifs-timeout-2.6.25.patch;
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

  cifs_timeout = cifs_timeout_2_6_29;

  no_xsave =
    { name = "no-xsave";
      patch = fetchurl {
        url = "http://kernel.ubuntu.com/git?p=rtg/ubuntu-maverick.git;a=blobdiff_plain;f=arch/x86/xen/enlighten.c;h=f7ff4c7d22954ab5eda464320241300bd5a32ee5;hp=1ea06f842a921557e958110e22941d53a2822f3c;hb=1a30f99;hpb=8f2ff69dce18ed856a8d1b93176f768b47eeed86";
        name = "no-xsave.patch";
        sha256 = "18732s3vmav5rpg6zqpiw2i0ll83pcc4gw266h6545pmbh9p7hky";
      };
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

  mips_restart_2_6_36 =
    { name = "mips_restart_2_6_36";
      patch = ./mips_restart.patch;
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

  glibc_getline =
    {
      # Patch to work around conflicting types for the `getline' function
      # with recent Glibcs (2009).
      name = "glibc-getline";
      patch = ./getline.patch;
    };
}
