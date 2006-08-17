let {
  pkgs =
    import ./all-packages.nix {
      system = "i686-mingw";
    };

  body = {
    inherit (pkgs) zlib getopt realCurl;
  };
}
