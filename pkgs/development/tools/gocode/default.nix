{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gocode-${version}";
  version = "20170219-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "f54790e5d4386b60b80d0c6f9e59db345839d7cc";

  goPackagePath = "github.com/nsf/gocode";

  src = fetchFromGitHub {
    inherit rev;
    owner = "nsf";
    repo = "gocode";
    sha256 = "1x9wdahpdkqwqkipxl5m0sh8d59i389rdvrsyz57slpfd0hapkks";
  };
}
