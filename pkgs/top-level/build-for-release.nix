let {

  allPackages = import ./all-packages.nix;

  i686LinuxPkgs = {inherit (allPackages {system = "i686-linux";})
    MPlayer
    MPlayerPlugin
    abc
    apacheAntBlackdown14
    apacheHttpd
    aspectj
    aterm
    autoconf
    automake19x
    bash
    batik
    binutils
    bisonnew
    bittorrent
    blackdown
    bmp
    bmp_plugin_musepack
    bsdiff
    bzip2
    chatzilla
    cksfv
    coreutils
    darcs
    db4
    diffutils
    docbook5
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xml_xslt
    ecj
    emacs
    enscript
    file
    findutils
    firefoxWrapper
    flexnew
    gaim
    gawk
    gcc
    gcc34
    gcc40
    ghcWrapper
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
#    inkscape
    jakartaregexp
    jetty
    jikes
    jing_tools
    jre
    kcachegrind
#    kernel
    less
    libtool
    libxml2
    libxslt
    lynx
    maven
    mk
    mktemp
    mono
    mysql
    nix
    nxml
#    octave
    openssl
    pan
    par2cmdline
    parted
    perl
    php
    pkgconfig
    postgresql
    postgresql_jdbc
    python
    qcmm
    qt3
#    qtparted
    quake3demo
    readline
#    rssglx
    screen
    sdf
    spidermonkey
    strace
    strategoxt
    strategoxtUtils
    subversion
    sylpheed
    tetex
    texinfo
    thunderbird
    tightvnc
    transformers
    uml
    unzip
#    uuagc
    uulib
    valgrind
    vim
    vlc
    wget
    xchm
    xineUI
    xmltv
    xmms
    xorg_sys_opengl
    xsel
#    zapping
    zdelta
    zip
#    atermjava
#    fspot
#    ghc
#    helium
#    hevea
#    jakartabcel
#    jjtraveler
#    monodevelop
#    monodoc
#    ocaml
#    ov511
#    sharedobjects
#    xauth
#    xawtv
  ;};

  i686FreeBSDPkgs = {inherit (allPackages {system = "i686-freebsd";})
    aterm
    autoconf
    automake19x
    docbook5
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xml_xslt
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
    bisonnew
    docbook5
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xml_xslt
    libtool
    libxml2
    libxslt
    maven
    nxml
    php
#    spidermonkey
    subversion
    tetex
    unzip
#    flexnew
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
  ;};

  body = [
    i686LinuxPkgs
    i686FreeBSDPkgs
    powerpcDarwinPkgs
    i686DarwinPkgs
    cygwinPkgs
  ];
}
