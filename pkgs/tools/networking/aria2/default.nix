{ stdenv, fetchurl, openssl, libxml2, zlib }:

stdenv.mkDerivation rec {
  name = "aria2-1.10.8";

  src = fetchurl {
    url = "mirror://sourceforge/aria2/stable/${name}/${name}.tar.bz2";
    sha256 = "1cbcrxwdc6gp4l4zqg2i18zdg5ry5f9r3zj66kx6l5plwfjv9fdc";
  };

  buildInputs = [ openssl libxml2 zlib ];

  meta = {
    homepage = http://aria2.sourceforge.net/;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
  };
}
