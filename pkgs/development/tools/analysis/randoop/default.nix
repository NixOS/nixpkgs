{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "4.3.2";
  pname = "randoop";

  src = fetchurl {
    url = "https://github.com/randoop/randoop/releases/download/v${version}/${pname}-${version}.zip";
    sha256 = "sha256-lcYI0Yns/R5VeOUG68Xe8h1BO8wlKvL1CZIqzWkgsqo=";
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
