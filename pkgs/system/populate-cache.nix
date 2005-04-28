let {

  i686LinuxPkgs = {inherit (import ./i686-linux.nix)
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
    sdf2_bundle
    strategoxt
#    ghc
#    helium
    perl
    python
    libxml2
    libxslt
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xml_ebnf_dtd
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
    fspot
    hello
    xchm
    nxml
    uml
    nix
#    ocaml
    mono
    monodoc
    monodevelop
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

    mysql
    postgresql
    jetty
    blackdown
    apacheAntBlackdown14
  ;};

  powerpcDarwinPkgs = {inherit (import ./powerpc-darwin.nix)
    unzip
    aterm
    subversion
    bisonnew
#    flexnew
    libxml2
    libxslt
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xml_ebnf_dtd
    docbook_xml_xslt
    nxml
  ;};


  body = [
    i686LinuxPkgs
    powerpcDarwinPkgs
  ];
}
