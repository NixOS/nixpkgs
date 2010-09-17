{ fetchurl }:

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

in

{

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
    { # From <http://people.redhat.com/roland/utrace/>.
      name = "tracehook";
      patch = fetchurl {
        url = http://people.redhat.com/roland/utrace/2.6.32/tracehook.patch;
        sha256 = "1y009p8dyqknbjm8ryb495jqmvl372gfhswdn167xh2g1f24xqv8";
      };
    };

  utrace_2_6_32 =
    { # From <http://people.redhat.com/roland/utrace/>, depends on the
      # `tracehook' patch above.
      # See also <http://sourceware.org/systemtap/wiki/utrace>.
      name = "utrace";
      patch = fetchurl {
        url = http://people.redhat.com/roland/utrace/2.6.32/utrace.patch;
        sha256 = "1951mwc8jfiwrl0d2bb1zk9yrl7n7kadc00ymjsxrg2irda1b89r";
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
    };

  aufs2_2_6_34 =
    { # From http://git.c3sl.ufpr.br/gitweb?p=aufs/aufs2-standalone.git;a=tree;h=refs/heads/aufs2-34;hb=aufs2-34
      # Note that this merely the patch needed to build AUFS2 as a
      # standalone package.
      name = "aufs2";
      patch = ./aufs2-34.patch;
      features.aufsBase = true;
    };

  aufs2_2_6_35 =
    { # From http://git.c3sl.ufpr.br/gitweb?p=aufs/aufs2-standalone.git;a=tree;h=refs/heads/aufs2-35;hb=aufs2-35
      # Note that this merely the patch needed to build AUFS2 as a
      # standalone package.
      name = "aufs2";
      patch = ./aufs2-35.patch;
      features.aufsBase = true;
    };

  # Increase the timeout on CIFS requests from 15 to 120 seconds to
  # make CIFS more resilient to high load on the CIFS server.
  cifs_timeout =
    { name = "cifs-timeout";
      patch = ./cifs-timeout.patch;
      features.cifsTimeout = true;
    };

  no_xsave =
    { name = "no-xsave";
      patch = fetchurl {
        url = "http://cvs.fedoraproject.org/viewvc/devel/kernel/fix_xen_guest_on_old_EC2.patch?revision=1.1&view=co";
        name = "no-xsave.patch";
        sha256 = "02f51f9b636b105c81a3ed62145abdc0ecb043b8114eb10257854577f617f894";
      };
      features.noXsave = true;
    };

  dell_rfkill =
    { name = "dell-rfkill";
      patch = ./dell-rfkill.patch;
    };

  guruplug_defconfig =
    {
      # Default configuration for the GuruPlug.  From
      # <http://www.openplug.org/plugwiki/images/c/c6/Guruplug-patchset-2.6.33.2.tar.bz2>.
      name = "guruplug-defconfig";
      patch = ./guruplug-defconfig.patch;
    };

  guruplug_arch_number =
    {
      # Hack to match the `arch_number' of the U-Boot that ships with the
      # GuruPlug.  This is only needed when using this specific U-Boot
      # binary.  See
      # <http://www.plugcomputer.org/plugwiki/index.php/Compiling_Linux_Kernel_for_the_Plug_Computer>.
      name = "guruplug-arch-number";
      patch = ./guruplug-mach-type.patch;
    };
}
