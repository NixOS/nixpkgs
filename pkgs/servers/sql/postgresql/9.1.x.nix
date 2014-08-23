{ stdenv, fetchurl, zlib, readline }:

let version = "9.1.14"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "d0647ce563d18ae02bf68c5dd646a4c75e8b45b3a4fada64d481371fdc16f522";
  };

  buildInputs = [ zlib readline ];

  enableParallelBuilding = true;

  LC_ALL = "C";

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
    license = "bsd";
    maintainers = [ stdenv.lib.maintainers.ocharles ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
