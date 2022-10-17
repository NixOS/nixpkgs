{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "4.3.1";
  pname = "randoop";

  src = fetchurl {
    url = "https://github.com/randoop/randoop/releases/download/v${version}/${pname}-${version}.zip";
    sha256 = "sha256-GWg3W/jjDKH6BcvjGt215J03NiDVWihU/m+2kejPVPA=";
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
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
