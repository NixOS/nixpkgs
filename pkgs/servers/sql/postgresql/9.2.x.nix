{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  psqlSchema = "9.2";
  version = "${psqlSchema}.11";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/postgresql-${version}.tar.bz2";
    sha256 = "1k5i73ninqyz76zzpi06ajj5qawf30zwr16x8wrgq6swzvsgbck5";
  };

  patches = [ ./disable-resolve_symlinks.patch ];
})
