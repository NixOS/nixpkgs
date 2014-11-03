{stdenv, fetchurl, unzip, libtommath}:

stdenv.mkDerivation {
  name = "convertlit-1.8";
  
  src = fetchurl {
    url = http://www.convertlit.com/convertlit18src.zip;
    sha256 = "1fjpwncyc2r3ipav7c9m7jxy6i7mphbyqj3gsm046425p7sqa2np";
  };

  buildInputs = [unzip libtommath];

  sourceRoot = ".";

  buildPhase = ''
    cd lib
    make
    cd ../clit18
    substituteInPlace Makefile --replace ../libtommath-0.30/libtommath.a -ltommath
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp clit $out/bin
  '';

  meta = {
    homepage = http://www.convertlit.com/;
    description = "A tool for converting Microsoft Reader ebooks to more open formats";
    license = stdenv.lib.licenses.gpl2;
  };
}
