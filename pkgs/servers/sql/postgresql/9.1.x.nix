{ stdenv, fetchurl, zlib, readline, openssl }:

let version = "9.1.18"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "1a44hmcvfaa8j169ladsibmvjakw6maaxqkzz1ab8139cqkda9i7";
  };

  outputs = [ "out" "doc" ];

  buildInputs = [ zlib readline openssl ];

  enableParallelBuilding = true;

  LC_ALL = "C";

  configureFlags = [ "--with-openssl" ];

  patches = [ ./less-is-more.patch ];

  postInstall =
    ''
      mkdir -p $out/share/man
      cp -rvd doc/src/sgml/man1 $out/share/man
      mkdir -p $doc
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
