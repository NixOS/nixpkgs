let {
  pkgs =
    import ./all-packages.nix {
      stdenvType = "i686-mingw";
    };

  body = {
    inherit (pkgs) zlib getopt realCurl aterm pkgconfig_latest;
    inherit (pkgs.gtkLibs28) glib;
  };
}
