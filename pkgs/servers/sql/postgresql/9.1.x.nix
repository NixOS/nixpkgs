{ stdenv, fetchurl, zlib, readline }:

let version = "9.1.9"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "1n1dc1kqc487dylc22iq1j8sn93jxbqm2g4b5rr0i4q0h7hk7998";
  };

  buildInputs = [ zlib readline ];

  enableParallelBuilding = true;

  LC_ALL = "C";

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
  };
}
