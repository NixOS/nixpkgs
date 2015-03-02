{ stdenv, fetchurl, zlib, readline, libossp_uuid }:

with stdenv.lib;

let version = "9.3.6"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "056ass7nnfyv7blv02anv795kgpz77gipdpxggd835cdwrhwns13";
  };

  buildInputs = [ zlib readline ] ++ optionals (!stdenv.isDarwin) [ libossp_uuid ];

  enableParallelBuilding = true;

  makeFlags = [ "world" ];

  configureFlags = optional (!stdenv.isDarwin)
    ''
      --with-ossp-uuid
    '';

  patches = [ ./disable-resolve_symlinks.patch ./less-is-more.patch ];

  installTargets = [ "install-world" ];

  LC_ALL = "C";

  passthru = {
    inherit readline;
    psqlSchema = "9.3";
  };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = stdenv.lib.licenses.postgresql;
    maintainers = [ stdenv.lib.maintainers.ocharles ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
