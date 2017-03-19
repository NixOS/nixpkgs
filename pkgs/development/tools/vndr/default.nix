{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vndr-${version}";
  version = "20161110-${lib.strings.substring 0 7 rev}";
  rev = "cf8678fba5591fbacc4dafab1a22d64f6c603c20";

  goPackagePath = "github.com/LK4D4/vndr";

  src = fetchFromGitHub {
    inherit rev;
    owner = "LK4D4";
    repo = "vndr";
    sha256 = "1fbrpdpfir05hqj1dr8rxw8hnjkhl0xbzncxkva56508vyyzbxcs";
  };

  meta = {
    description = "Stupid golang vendoring tool, inspired by docker vendor script";
    homepage = "https://github.com/LK4D4/vndr";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.asl20;
  };
}
