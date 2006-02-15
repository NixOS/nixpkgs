let {

  allPackages = import ./all-packages.nix;

  i686LinuxPkgs = {inherit (allPackages {system = "i686-linux";})
    MPlayer
    MPlayerPlugin
    apacheAntBlackdown14
    apacheHttpd
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
    callgrind
    chatzilla
    cksfv
    coreutils
    darcs
    db4
    diffutils
    docbook_ng
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
    gcc40
    gccWrapped
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
    inkscape
    jakartaregexp
    jetty
    jikes
    jing_tools
    jre
    kcachegrind
    kernel
    less
    libtool
    libxml2
    libxslt
    lynx
    mk
    mktemp
    mono
    mysql
    nix
    nxml
    octave
    openssl
    pan
    par2cmdline
    parted
    perl
    pkgconfig
    postgresql
    postgresql_jdbc
    python
    qcmm
    qt3
    qtparted
    quake3demo
    readline
    rssglx
    screen
    sdf
    strace
    strategoxt
    strategoxtUtils
    subversion
    sylpheed
    tetex
    texinfo
    thunderbird
    transformers
    uml
    unzip
    uuagc
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
    xulrunner
    zapping
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
    curl
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xml_xslt
    libxml2
    libxslt
    nxml
    subversion
    unzip
  ;};

  powerpcDarwinPkgs = {inherit (allPackages {system = "powerpc-darwin";})
    aterm
    autoconf
    automake19x
    bisonnew
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xml_xslt
    libtool
    libxml2
    libxslt
    nxml
    pkgconfig
    subversion
    tetex
    unzip
#    flexnew
  ;};

  body = [
    i686LinuxPkgs
    i686FreeBSDPkgs
    powerpcDarwinPkgs
  ];
}
