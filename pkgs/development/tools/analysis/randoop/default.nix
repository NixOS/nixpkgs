{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "4.2.2";
  pname = "randoop";

  src = fetchurl {
    url = "https://github.com/randoop/randoop/releases/download/v${version}/${pname}-${version}.zip";
    sha256 = "1ac4llphh16n5ihc2hb1vggl65mbkw1xd1j3ixfskvmcy8valgqw";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/lib $out/doc

    cp -R *.jar $out/lib
    cp README.txt $out/doc
  '';

  meta = with stdenv.lib; {
    description = "Automatic test generation for Java";
    homepage = "https://randoop.github.io/randoop/";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
