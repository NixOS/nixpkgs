let {
  pkgs = import ./i686-linux.nix;
  body = 
    [
      pkgs.coreutils
      pkgs.findutils
      pkgs.diffutils
      pkgs.gnupatch
      pkgs.gnused
      pkgs.gnugrep
      pkgs.gawk
      pkgs.gnutar
      pkgs.zip
      pkgs.unzip
      pkgs.gzip
      pkgs.bzip2
      pkgs.wget
      pkgs.par2cmdline
      pkgs.cksfv
#      pkgs.bittorrent
      pkgs.graphviz
      pkgs.bash
      pkgs.binutils
      pkgs.gnum4
      pkgs.valgrind
      pkgs.texinfo
      pkgs.octavefront
      pkgs.gnumake
      pkgs.bisonnew
      pkgs.flexnew
      pkgs.gcc
      pkgs.strategoxt
      pkgs.ghc
      pkgs.helium
      pkgs.perl
      pkgs.python
      pkgs.libxml2
      pkgs.libxslt
      pkgs.docbook_xml_dtd
      pkgs.docbook_xml_xslt
      pkgs.subversion
      pkgs.pan
      pkgs.sylpheed
#      pkgs.firefox
      pkgs.MPlayer
      pkgs.MPlayerPlugin
#      pkgs.vlc
      pkgs.zapping
#      pkgs.gqview
      pkgs.hello
      pkgs.nxml
      pkgs.uml
      pkgs.nix
    ];
}
