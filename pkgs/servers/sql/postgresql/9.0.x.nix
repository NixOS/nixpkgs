{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  psqlSchema = "9.0";
  version = "${psqlSchema}.20";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/postgresql-${version}.tar.bz2";
    sha256 = "0vxa90d1ghv6vg4c6kxvm2skypahvlq4sd968q7l9ff3dl145z02";
  };
})
