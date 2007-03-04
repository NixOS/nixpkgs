let {

  allPackages = import ./all-packages.nix;

  i686LinuxPkgs = {inherit (allPackages {system = "i686-linux";})
    MPlayer
    MPlayerPlugin
    #abc
    apacheAntBlackdown14
    apacheHttpd
    aspectj
    aterm
    autoconf
    automake19x
    bash
    batik
    binutils
    bison23
    bittorrent
    blackdown
    bmp
    bmp_plugin_musepack
    bmp_plugin_wma
    bsdiff
    bzip2
    cdrtools
    chatzilla
    cksfv
    compiz
    coreutils
    cpio
    darcs
    db4
    dietlibc
    diffutils
    docbook5
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xsl
    docbook5_xsl
    e2fsprogs
    ecj
    emacs
    emacsUnicode
    enscript
    exult
    file
    findutils
    firefoxWrapper
    flex2533
    gaim
    gawk
    gcc
    gcc34
    ghc
    ghostscript
    gnugrep
    gnum4
    gnumake
    gnupatch
    gnused
    gnutar
    gqview
    graphviz
    grub
    gzip
    hello
    iputils
    jakartaregexp
    jetty
    jikes
    jing_tools
    jre
    kcachegrind
    keen4
    kernel
    klibc
    lvm2
    less
    lhs2tex
    libtool
    libxml2
    libxslt
    lynx
    man
    #maven
    mdadm
    mesa
    mk
    mktemp
    mod_python
    module_init_tools
    mono
    mysql
    mythtv
    nano
    netcat
    nix
    nixUnstable
    ntp    
    nxml
    openssh
    openssl
    pam_login
    pam_unix2
    pan
    par2cmdline
    #parted
    perl
    php
    pkgconfig
    postgresql
    postgresql_jdbc
    procps
    pwdutils
    python
    qcmm
    qt3
    quake3demo
    readline
    rsync
    screen
    sdf
    slim
    spidermonkey
    splashutils
    strace
    strategoxt
    strategoxtUtils
    su
    subversion
    swig
    sylpheed 
    sysklogd
    sysvinit
    tetex
    texinfo
    thunderbird
    tightvnc
#    transformers
    udev
    uml
    unzip
    upstart
    utillinux
#    uulib
    valgrind
    vim
    vlc
    wget
    wxHaskell
    xchm
    xfig
    xineUI
    xmltv
    xmms
    xorg_sys_opengl
    xsel
    xterm
    zdelta
    zip
#    atermjava
#    fspot
#    ghc
#    helium
#    hevea
#    inkscape
#    jakartabcel
#    jjtraveler
#    kernel
#    monodevelop
#    monodoc
#    ocaml
#    octave
#    ov511
#    qtparted
#    rssglx
#    sharedobjects
#    uuagc
#    xauth
#    xawtv
#    zapping
    ;
  inherit ((allPackages {system = "i686-linux";}).xorg)
    xorgserver
    xf86inputkeyboard
    xf86inputmouse
    xf86videovesa
    xf86videoi810
    fontbhttf
    fontbhlucidatypewriter100dpi
    fontbh100dpi
    fontmiscmisc
    fontcursormisc
    ;
  inherit ((allPackages {system = "i686-linux";}).gnome)
    metacity
    gconfeditor
    gnometerminal
    ;
  };

  powerpcLinuxPkgs = {inherit (allPackages {system = "powerpc-linux";})
    aterm
  ;};
  
  i686FreeBSDPkgs = {inherit (allPackages {system = "i686-freebsd";})
    aterm
    autoconf
    automake19x
    docbook5
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xsl
    docbook5_xsl
    libtool
    libxml2
    libxslt
    nxml
    realCurl
    subversion
    unzip
  ;};

  powerpcDarwinPkgs = {inherit (allPackages {system = "powerpc-darwin";})
    apacheHttpd
    aterm
    autoconf
    automake19x
    bison23
    docbook5
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xsl
    docbook5_xsl
    libtool
    libxml2
    libxslt
#    maven
    nxml
    php
#    spidermonkey
    subversion
    tetex
    unzip
#    flex2533
  ;};

  i686DarwinPkgs = {inherit (allPackages {system = "i686-darwin";})
    aterm
    autoconf
    automake19x
    libtool
    libxml2
    libxslt
    subversion
  ;};

  cygwinPkgs = {inherit (allPackages {system = "i686-cygwin";})
    aterm
    gnum4
    readline
    ncurses
  ;};

  body = [
    i686LinuxPkgs
    powerpcLinuxPkgs
    i686FreeBSDPkgs
    powerpcDarwinPkgs
#    i686DarwinPkgs
    cygwinPkgs
  ];
}
