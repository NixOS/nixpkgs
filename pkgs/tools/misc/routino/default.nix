{ stdenv, fetchurl, perl, zlib, bzip2 }:

stdenv.mkDerivation rec {
  pname = "routino";
  version = "3.2";

  src = fetchurl {
    url = "https://routino.org/download/${pname}-${version}.tgz";
    sha256 = "0lkmpi8gn7qf40cx93jcp7nxa9dfwi1d6rjrhcqbdymszzm33972";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ zlib bzip2 ];

  outputs = [ "out" "doc" ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://www.routino.org/;
    description = "OpenStreetMap Routing Software";
    license = licenses.agpl3;
    maintainers = with maintainers; [ dotlambda ];
    platforms = with platforms; linux;
  };
}
