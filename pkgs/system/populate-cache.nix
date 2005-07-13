let {

  allPackages = import ./all-packages.nix;

  i686LinuxPkgs = {inherit (allPackages {system = "i686-linux";})
    coreutils
    findutils
    diffutils
    gnupatch
    gnused
    gnugrep
    gawk
    enscript
    gnutar
    zip
    unzip
    gzip
    bzip2
    zdelta
    bsdiff
    wget
    par2cmdline
    cksfv
    bittorrent
    graphviz
    bash
    binutils
    gnum4
    autoconf
    automake19x
    libtool
    pkgconfig
    valgrind
    texinfo
    readline
    octave
    gnumake
    bisonnew
    flexnew
    gccWrapped
    aterm

#    atermjava
#    jjtraveler
#    sharedobjects
#    jakartabcel
    jakartaregexp

    sdf
    strategoxt
    strategoxtUtils
#    ghc
#    helium
    perl
    python
    libxml2
    libxslt
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xml_xslt
    subversion
    pan
    sylpheed
    firefoxWrapper
    thunderbird
    lynx
    MPlayer
    MPlayerPlugin
    vlc
    xineUI
    zapping
    gqview
#    fspot
    hello
    xchm
    nxml
    uml
    nix
#    ocaml
    mono
#    monodoc
#    monodevelop
#    hevea
    vim
    less
    file
    screen
    xsel
    openssl
    mktemp
    strace
    qt3
    xmltv
    mythtv
    tetex
    ghostscript

    mysql
    postgresql
    postgresql_jdbc

    blackdown
    apacheAntBlackdown14
    jikes
    jetty
  ;};

  i686FreeBSDPkgs = {inherit (allPackages {system = "i686-freebsd";})
    unzip
    aterm
    subversion
    curl
    libxml2
    libxslt
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xml_xslt
    nxml
  ;};

  powerpcDarwinPkgs = {inherit (allPackages {system = "powerpc-darwin";})
    unzip
    aterm
    subversion
    bisonnew
#    flexnew
    libxml2
    libxslt
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xml_xslt
    nxml
  ;};


  body = [
    i686LinuxPkgs
    i686FreeBSDPkgs
    powerpcDarwinPkgs
  ];
}
