{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.3.11"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";
  
  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "1nvjcsa0218849r2913mxia58cjgcw6rikkf1g7kmjb902lv3aw1";
  };

  buildInputs = [ zlib ncurses readline ];

  LC_ALL = "en_US";

  passthru = { inherit readline; };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = "bsd";
  };
}
