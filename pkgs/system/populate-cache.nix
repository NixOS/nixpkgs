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
    wget
    par2cmdline
    cksfv
    bittorrent
    graphviz
    bash
    binutils
    gnum4
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
    xdoc
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
    zapping
    gqview
    hello
    xchm
    nxml
    uml
    nix
#    ocaml
#    hevea
    vim
    less
    screen
    xsel
    openssl
    mktemp
    strace

    postgresql
    jetty
    blackdown
    apacheAntBlackdown14
    subversionWithJava
  ;};

  powerpcDarwinPkgs = {inherit (import ./powerpc-darwin.nix)
    aterm
    subversion
  ;};


  body = [
    i686LinuxPkgs
    powerpcDarwinPkgs
  ];
}
