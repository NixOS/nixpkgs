{ stdenv, fetchurl, openssl, libxml2, zlib }:

stdenv.mkDerivation rec {
  name = "aria2-1.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/aria2/stable/${name}/${name}.tar.bz2";
    sha256 = "04vnvq5f797bbyrrv1kzvnv8h02f4wbhvsl34syi4gygimfrwkrn";
  };

  buildInputs = [ openssl libxml2 zlib ];

  meta = {
    homepage = http://aria2.sourceforge.net/;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
  };
}
