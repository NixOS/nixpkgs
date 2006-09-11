let {
  pkgs =
    import ./all-packages.nix {
      stdenvType = "i686-mingw";
    };

  body = {
    inherit (pkgs)
      aterm
      getopt
      pkgconfig
      realCurl
      strategoLibraries
      zlib;
#    inherit profileTest;
  };

#  profileTest =
#    pkgs.stdenv.mkDerivation {
#      name = "profile-test";
#      src = ./char-test.c;
#      builder = ./profile-builder.sh;
#      strlib = pkgs.strategoLibraries;
#      aterm = pkgs.aterm;
#      buildInputs = [pkgs.aterm pkgs.strategoLibraries];
#    };
}
