{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  pname = "gpup";
  version = "1.6.1";
  rev = "95727c319393a0c7d2add7cc0f454f158989a966";

  goPackagePath = "github.com/int128/gpup";

  src = fetchFromGitHub {
    inherit rev;
    owner = "int128";
    repo = "gpup";
    sha256 = "0nw9z96x1vk0gm09cz1yy2f870hyn4djb02qhn1f24m58s8mshqj";
  };

}
