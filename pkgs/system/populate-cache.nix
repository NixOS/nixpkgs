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
  ;};


  powerpcDarwinPkgs = {inherit (import ./powerpc-darwin.nix)
    aterm
    hello
  ;};


  body = [
    i686LinuxPkgs
    powerpcDarwinPkgs
  ];   
}
