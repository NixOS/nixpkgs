{ stdenv, fetchurl, zlib, readline, openssl }:

let version = "9.1.15"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "0pyyw0cy91z9wkqf8qzkwsy8cyjps0s94c9czz6mzhyd2npxxmk7";
  };

  buildInputs = [ zlib readline openssl ];

  enableParallelBuilding = true;

  LC_ALL = "C";

  configureFlags = [ "--with-openssl" ];

  patches = [ ./less-is-more.patch ];

  postInstall =
    ''
      mkdir -p $out/share/man
      cp -rvd doc/src/sgml/man1 $out/share/man
    '';

  passthru = {
    inherit readline;
    psqlSchema = "9.1";
  };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = stdenv.lib.licenses.postgresql;
    maintainers = [ stdenv.lib.maintainers.ocharles ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
