{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "compile-daemon-unstable";
  version = "2017-03-08";
  rev = "d447e567232bcb84cedd3b2be012c7127f31f469";

  goPackagePath = "github.com/githubnemo/CompileDaemon";

  src = fetchFromGitHub {
    owner = "githubnemo";
    repo = "CompileDaemon";
    inherit rev;
    sha256 = "0jfbipp3gd89n6d7gds1qvfkqvz80qdlqqhijxffh8z8ss0xinqc";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Very simple compile daemon for Go";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    inherit (src.meta) homepage;
  };
}
