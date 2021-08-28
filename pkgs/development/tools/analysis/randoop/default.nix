{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "4.2.5";
  pname = "randoop";

  src = fetchurl {
    url = "https://github.com/randoop/randoop/releases/download/v${version}/${pname}-${version}.zip";
    sha256 = "0v3vla3k6csfb8w0j9njrhcjj4n7yh172n9wv6z397f1sa0fs202";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/lib $out/doc

    cp -R *.jar $out/lib
    cp README.txt $out/doc
  '';

  meta = with lib; {
    description = "Automatic test generation for Java";
    homepage = "https://randoop.github.io/randoop/";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
