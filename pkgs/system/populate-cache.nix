let {
  pkgs = import ./i686-linux.nix;
  body = 
    [ pkgs.subversion
      pkgs.pan
      pkgs.sylpheed
      pkgs.MPlayer
      pkgs.MPlayerPlugin
      pkgs.gqview
      pkgs.vlc
    ];
}
