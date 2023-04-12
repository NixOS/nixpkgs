{ pkgs ? import <nixpkgs> {} }:

let
  xjump = pkgs.stdenv.mkDerivation {
    name = "xjump-sdl";
    version = "3.0.4";
    src = pkgs.fetchFromGitHub {
      owner = "hugomg";
      repo = "xjump-sdl";
      rev = "ca9af83a62806556ce63bd833bf2f67c81eef4b8";
      sha256 = "PiUFfV/fKe79ZYitYbUChEkBO6bsW5XXHIl9gBWhTNU=";
    };
    buildInputs = [ pkgs.SDL2 ];
    preConfigure = "./configure";
    installPhase = "make && make install";
    meta = with pkgs.lib; {
      description = "The falling tower game";
      license = licenses.gpl3;
      maintainers = with maintainers; [ ];
    };
  };
in xjump
