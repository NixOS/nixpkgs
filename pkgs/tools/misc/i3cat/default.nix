{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "i3cat-${version}";
  version = "20150321-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "b9ba886a7c769994ccd8d4627978ef4b51fcf576";

  goPackagePath = "github.com/vincent-petithory/i3cat";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/vincent-petithory/i3cat";
    sha256 = "1xlm5c9ajdb71985nq7hcsaraq2z06przbl6r4ykvzi8w2lwgv72";
  };

  goDeps = ./deps.json;
}
