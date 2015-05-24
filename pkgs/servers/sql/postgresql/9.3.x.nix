{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  psqlSchema = "9.3";
  version = "${psqlSchema}.7";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/postgresql-${version}.tar.bz2";
    sha256 = "0ggz0i91znv053zx9qas7pjf93s5by3dk84z1jxbjkg8yyrnlx4b";
  };
})
