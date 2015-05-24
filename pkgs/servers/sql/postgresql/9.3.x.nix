{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  psqlSchema = "9.3";
  version = "${psqlSchema}.7";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/postgresql-${version}.tar.bz2";
    sha256 = "09iqr9sldiq7jz1rdnywp2wv36lxy5m8kch3vpchd1s4fz75c7aw";
  };
})
