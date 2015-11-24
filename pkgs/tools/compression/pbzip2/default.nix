{stdenv, fetchurl, bzip2}:

let major = "1.1";
    version = "${major}.9";
in
stdenv.mkDerivation rec {
  name = "pbzip2-${version}";

  src = fetchurl {
    url = "https://launchpad.net/pbzip2/${major}/${version}/+download/${name}.tar.gz";
    sha256 = "1i7rql77ac33lz7lzrjyl9b16mqizmdkb8hv295a493f7vh1nhmx";
  };

  buildInputs = [ bzip2 ];

  preBuild = if !stdenv.cc.isGNU then ''substituteInPlace Makefile --replace g++ c++'' else '''';

  installPhase = ''
      make install PREFIX=$out
  '';

  meta = with stdenv.lib; {
    homepage = http://compression.ca/pbzip2/;
    description = "A parallel implementation of bzip2 for multi-core machines";
    license = licenses.bsd2;
    maintainers = with maintainers; [viric];
    platforms = platforms.unix;
  };
}
