{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "4.2.6";
  pname = "randoop";

  src = fetchurl {
    url = "https://github.com/randoop/randoop/releases/download/v${version}/${pname}-${version}.zip";
    sha256 = "sha256-69cKAyMwORG4A91OARmY4uQKgBZIx9N/zc7TZ086CK0=";
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
