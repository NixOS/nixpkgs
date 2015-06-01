{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "9.1.16";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/postgresql-${version}.tar.bz2";
    sha256 = "0mllj1r1648iwm0qj3cj9qxizhlyhqmz94iydnwhf48psvvy4r9b";
  };
})
