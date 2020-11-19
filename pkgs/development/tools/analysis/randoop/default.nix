{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "4.2.4";
  pname = "randoop";

  src = fetchurl {
    url = "https://github.com/randoop/randoop/releases/download/v${version}/${pname}-${version}.zip";
    sha256 = "1p6l5xzz7cbhrk5wy3906llhnwk0l8nck53pvi0l57kz7bdnag5w";
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
