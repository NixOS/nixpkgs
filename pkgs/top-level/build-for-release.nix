let

  allPackages = import ./all-packages.nix;

  # Packages that we want to build on i686-linux and x86_64-linux.
  commonLinuxPkgs = system: let pkgs = allPackages {inherit system;}; in {
    inherit (pkgs)
      MPlayer
      MPlayerPlugin
      alsaUtils
      apacheHttpd
      aspell
      aspellDicts
      audacious
      audacious_plugins
      autoconf
      automake19x
      bash
      bashInteractive
      binutils
      bison23
      bitlbee
      bittorrent
      bsdiff
      bzip2
      cabextract
      cdrkit
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
      ghc
      ghostscript
      gimp
      gnash
      gnugrep
      gnum4
      gnumake
      gnupatch
      gnused
      gnutar
      gnutls
      guile
      gqview
      graphviz
      grub
      gzip
      hal
      hello
      iana_etc
      inkscape
      iputils
      irssi
      jwhois
      kbd
      kcachegrind
      kdebase
      ktorrent
      kvm
      less
      lhs2tex
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
      pkgconfig
      postgresql
      procps
      pwdutils
      python
      qt3
      qt4
      #quake3demo
      readline
      reiserfsprogs
      rLang
      rogue
      rsync
      ruby
      screen
      seccure
      slim
      spidermonkey
      ssmtp
      strace
      su
      subversion14
      subversion15
      sudo
      swig
      sylpheed 
      sysklogd
      sysvinit
      sysvtools
      #tetex
      texLive
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
      w3m
      wget
      wirelesstools
      wxHaskell
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
      zip
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
    kernelPackages_2_6_23 = pkgs.recurseIntoAttrs {
      inherit (pkgs.kernelPackages_2_6_23)
        iwlwifi
        kernel
        klibc
        splashutils
        ;
    };
    kernelPackages_2_6_25 = pkgs.recurseIntoAttrs {
      inherit (pkgs.kernelPackages_2_6_25)
        kernel
        klibc
#        splashutils
        ;
    };
    kernelPackages_2_6_26 = pkgs.recurseIntoAttrs {
      inherit (pkgs.kernelPackages_2_6_26)
        kernel
        klibc
#        splashutils
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
      openoffice
      pidgin
      postgresql_jdbc
      sdf
      strategoxt
      strategoxtUtils
      syslinux
      uml
      wine
      xorg_sys_opengl
      ;
  };

  x86_64LinuxPkgs = commonLinuxPkgs "x86_64-linux" // {
    inherit (allPackages {system = "x86_64-linux";})
      aterm242fixes
      gcc43multi
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
      automake19x
      automake110x
      libtool
      libxml2
      libxslt
      subversion
      ;
  };

  cygwinPkgs = {
    inherit (allPackages {system = "i686-cygwin";})
      aterm
      gnum4
      readline
      ncurses
      ;
  };

in [
  i686LinuxPkgs
  x86_64LinuxPkgs
  #i686FreeBSDPkgs
  #powerpcDarwinPkgs
  i686DarwinPkgs
  #cygwinPkgs
]
