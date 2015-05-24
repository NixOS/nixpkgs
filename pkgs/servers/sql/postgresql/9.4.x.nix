{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  psqlSchema = "9.4";
  version = "${psqlSchema}.2";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/postgresql-${version}.tar.bz2";
    sha256 = "04adpfg2f7ip96rh3jjygx5cpgasrrp1dl2wswjivfk5q68s3zc1";
  };
})
