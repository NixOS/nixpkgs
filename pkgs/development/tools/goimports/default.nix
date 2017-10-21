{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "goimports-${version}";
  version = "20160519-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "9ae4729fba20b3533d829a9c6ba8195b068f2abc";

  goPackagePath = "golang.org/x/tools";
  subPackages = [ "cmd/goimports" ];

  src = fetchgit {
    inherit rev;
    url = "https://go.googlesource.com/tools";
    sha256 = "1j51aaskfqc953p5s9naqimr04hzfijm4yczdsiway1xnnvvpfr1";
  };
}
