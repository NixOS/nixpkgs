let
  version = "8.3.4";
in { pkgs ? import <nixpkgs> {} }:
pkgs.appimageTools.wrapType2 {
  name = "fflogs";
  src = pkgs.fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-fflogs/releases/download/v${version}/fflogs-v${version}.AppImage";
    sha256 = "uYV2uB0rjlzBJCtAknOPXHugA5JZVxToHICtZuNY/lE=";
  };
}
