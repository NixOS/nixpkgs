{ stdenv, fetchurl, zlib, readline, openssl }:

let version = "9.1.16"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "0mllj1r1648iwm0qj3cj9qxizhlyhqmz94iydnwhf48psvvy4r9b";
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

  meta = with stdenv.lib; {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = licenses.postgresql;
    maintainers = [ maintainers.ocharles ];
    platforms = platforms.unix;
    hydraPlatforms = platforms.linux;
  };
}
