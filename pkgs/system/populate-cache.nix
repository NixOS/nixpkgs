let {
  pkgs = import ./i686-linux.nix;
  body = 
    [ pkgs.zip
      pkgs.unzip
      pkgs.par2cmdline
      pkgs.graphviz
      pkgs.strategoxt
      pkgs.libxml2
      pkgs.libxslt
      pkgs.docbook_xml_dtd
      pkgs.docbook_xml_xslt
      pkgs.subversion
      pkgs.pan
      pkgs.sylpheed
      pkgs.firebird
      pkgs.MPlayer
      pkgs.MPlayerPlugin
      pkgs.vlc
      pkgs.gqview
      pkgs.hello
      pkgs.nxml
    ];
}
