let

  allPackages = import ./all-packages.nix;

  # Packages that we want to build on i686-linux and x86_64-linux.
  commonLinuxPkgs = system: let pkgs = allPackages {inherit system;}; in {
    inherit (pkgs)
      MPlayer
      abcde
      alsaUtils
      apacheHttpd
      aspell
      aspellDicts
      at
      audacious
      audacious_plugins
      autoconf
      automake19x
      avahi
      bash
      bashInteractive
      binutils
      bison23
      bison24
      bitlbee
      bittorrent
      bsdiff
      bzip2
      cabextract
      cdrkit
      cedet
      chatzilla
      cksfv
      #compiz
      coreutils
      cpio
      cron
      cups
      #darcs
      db4
      dhcp
      dietlibc
      diffutils
      docbook5
      docbook5_xsl
      docbook_xml_dtd_42
      docbook_xml_dtd_43
      docbook_xsl
      doxygen
      e2fsprogs
      emacs
      emacsUnicode
      emms
      enscript
      evince
      expect
      exult
      feh
      file
      findutils
      firefox2
      firefox3
      flex2533
      gawk
      gcc
      gcc34
      gcc43
      gdb
      ghostscript
      gimp
      git
      /*gnash*/
      gnugrep
      gnum4
      gnumake
      gnupatch
      gnupg2
      gnused
      gnutar
      gnutls
      gphoto2
      gprolog
      gsl
      guile
      gqview
      graphviz
      grub
      gv
      gzip
      hal
      hello
      host
      iana_etc
      imagemagick
      inkscape
      iputils
      irssi
      jnettop
      jwhois
      kbd
      kcachegrind
      kdebase
      klibc
      ktorrent
      kvm
      less
      lftp
      libtool
      libxml2
      libxslt
      lout
      lvm2
      lynx
      man
      mc
      mdadm
      mesa
      mingetty
      mk
      mktemp
      mod_python
      module_init_tools
      mpg321
      mysql
      #mythtv
      nano
      netcat
      nfsUtils
      nix
      nixUnstable
      nss_ldap
      ntp    
      nxml
      #openoffice
      openssh
      openssl
      pam_console
      pam_ldap
      pam_login
      pam_unix2
      pan
      par2cmdline
      pciutils
      perl
      php
      pinentry
      pkgconfig
      portmap
      postgresql
      procps
      pwdutils
      python
      qt3
      qt4
      #quake3demo
      readline
      rLang
      reiserfsprogs
      rogue
      rpm
      rsync
      ruby
      screen
      seccure
      slim
      spidermonkey
      splashutils_13
      ssmtp
      strace
      su
      subversion15
      subversion16
      sudo
      superTuxKart
      swig
      sylpheed 
      sysklogd
      sysvinit
      sysvtools
      tcpdump
      teeworlds
      #tetex
      texLive
      texLiveBeamer
      texLiveExtra
      texinfo
      thunderbird
      tightvnc
      time
      udev
      unzip
      upstart
      utillinux
      valgrind
      vim
      vlc
      vorbisTools
      vpnc
      w3m
      wget
      wirelesstools
      x11_ssh_askpass
      xchm
      xfig
      xineUI
      xkeyboard_config
      xlockmore
      xmltv
      xpdf
      xscreensaver
      xsel
      xterm
      zdelta
      zile
      zip
      ;
    inherit (pkgs.perlPackages)
      TaskCatalystTutorial
      ;    
    inherit (pkgs.xorg)
      fontbh100dpi
      fontbhlucidatypewriter100dpi
      fontbhlucidatypewriter75dpi
      fontadobe100dpi
      fontadobe75dpi
      fontbhttf
      fontcursormisc
      fontmiscmisc
      iceauth
      setxkbmap
      xauth
      xf86inputkeyboard
      xf86inputmouse
      xf86videointel
      xf86videovesa
      xkbcomp
      xorgserver
      xrandr
      xrdb
      xset
      ;
    inherit (pkgs.gnome)
      gconfeditor
      gnomepanel
      gnometerminal
      gnomeutils
      metacity
      ;
    kde42 = pkgs.recurseIntoAttrs {
      inherit (pkgs.kde42)
        kdelibs
        kdebase_workspace
        kdebase
        kdebase_runtime
	kdegraphics
	kdemultimedia
	kdegames
	kdeadmin
	kdeedu
	kdeartwork
	kdesdk
	kdeutils
	kdetoys
	kdewebdev
	kdenetwork
	kdepim
	kdeplasma_addons
        ;
    };
    kernelPackages_2_6_23 = pkgs.recurseIntoAttrs {
      inherit (pkgs.kernelPackages_2_6_23)
        iwlwifi
        kernel
        ;
    };
    kernelPackages_2_6_25 = pkgs.recurseIntoAttrs {
      inherit (pkgs.kernelPackages_2_6_25)
        kernel
        ;
    };
    kernelPackages_2_6_26 = pkgs.recurseIntoAttrs {
      inherit (pkgs.kernelPackages_2_6_26)
        kernel
        ;
    };
    kernelPackages_2_6_27 = pkgs.recurseIntoAttrs {
      inherit (pkgs.kernelPackages_2_6_27)
        kernel
        ;
    };
    kernelPackages_2_6_28 = pkgs.recurseIntoAttrs {
      inherit (pkgs.kernelPackages_2_6_28)
        kernel
        ;
    };
  };

  i686LinuxPkgs = commonLinuxPkgs "i686-linux" // {
    inherit (allPackages {system = "i686-linux";})
      apacheAnt
      aspectj
      aterm
      automake110x
      batik
      ecj
      eclipsesdk
      ejabberd
      gcc33
      icecat3Xul
      jakartaregexp
      jdkPlugin
      jetty
      jikes
      jing_tools
      jrePlugin
      keen4
      mono
      namazu  # FIXME: The test suite fails on x86-64.
      openoffice
      pidgin
      postgresql_jdbc
      splashutils_15
      syslinux
      tinycc
      uml
      wine
      xorg_sys_opengl
      ;
  };

  x86_64LinuxPkgs = commonLinuxPkgs "x86_64-linux" // {
    inherit (allPackages {system = "x86_64-linux";})
      aterm242fixes
      gcc43_multi
      ;    
  };
  
  i686FreeBSDPkgs = {
    inherit (allPackages {system = "i686-freebsd";})
      aterm
      autoconf
      #automake19x
      curl
      docbook5
      docbook5_xsl
      docbook_xml_dtd_42
      docbook_xml_dtd_43
      docbook_xsl
      libtool
      libxml2
      libxslt
      nxml
      subversion
      unzip
      ;
  };

  powerpcDarwinPkgs = {
    inherit (allPackages {system = "powerpc-darwin";})
      apacheHttpd
      aterm
      autoconf
      #automake19x
      bison23
      docbook5
      docbook_xml_dtd_42
      docbook_xml_dtd_43
      docbook_xsl
      docbook5_xsl
      libtool
      libxml2
      libxslt
      nxml
      #php
      subversion
      #tetex
      unzip
      ;
  };

  i686DarwinPkgs = {
    inherit (allPackages {system = "i686-darwin";})
      aterm
      autoconf
      automake110x
      automake19x
      libtool
      libxml2
      libxslt
      nixUnstable
      subversion
      ;
  };

  cygwinPkgs = {
    inherit (allPackages {system = "i686-cygwin";})
      aterm
      autoconf
      automake110x
      automake19x
      gnum4
      libtool
      ncurses
      nixUnstable
      readline
      subversion
      ;
  };

in [
  i686LinuxPkgs
  x86_64LinuxPkgs
  #i686FreeBSDPkgs
  #powerpcDarwinPkgs
  i686DarwinPkgs
  cygwinPkgs
]
