{ stdenv, fetchurl, bzip2 }:

let major = "1.1";
    version = "${major}.12";
in
stdenv.mkDerivation rec {
  name = "pbzip2-${version}";

  src = fetchurl {
    url = "https://launchpad.net/pbzip2/${major}/${version}/+download/${name}.tar.gz";
    sha256 = "1vk6065dv3a47p86vmp8hv3n1ygd9hraz0gq89gvzlx7lmcb6fsp";
  };

  buildInputs = [ bzip2 ];

  preBuild = "substituteInPlace Makefile --replace g++ c++";

  installFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    homepage = http://compression.ca/pbzip2/;
    description = "A parallel implementation of bzip2 for multi-core machines";
    license = licenses.bsd2;
    maintainers = with maintainers; [viric];
    platforms = platforms.unix;
  };
}
