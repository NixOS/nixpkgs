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
    octavefront
    gnumake
    bisonnew
    flexnew
    gcc
    gcc34
    aterm
    strategoxt
    ghc
    helium
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
    firefox
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
    ocaml
    hevea
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
