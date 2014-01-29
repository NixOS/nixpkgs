{ stdenv, fetchurl, zlib, readline, libossp_uuid }:

let version = "9.3.2"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "700da51a71857e092f6af1c85fcd86b46d7d5cd2f2ba343cafb1f206c20232d7";
  };

  buildInputs = [ zlib readline libossp_uuid ];

  enableParallelBuilding = true;

  makeFlags = [ "world" ];

  configureFlags =
    ''
      --with-ossp-uuid
    '';

  patches = [ ./disable-resolve_symlinks.patch ];

  installTargets = [ "install-world" ];

  LC_ALL = "C";

  passthru = {
    inherit readline;
    psqlSchema = "9.3";
  };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = "bsd";
  };
}
