{ stdenv, lib, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "hexfiend";
  version = "2.16.0";

  src = fetchurl {
    url = "https://github.com/HexFiend/HexFiend/releases/download/v${version}/Hex_Fiend_${lib.versions.majorMinor version}.dmg";
    sha256 = "sha256-jO57bW5TyuQ0mjKKsSwDoGLp2TZ1d+m159flVGaVrLc=";
  };

  sourceRoot = "Hex Fiend.app";
  nativeBuildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/Hex Fiend.app"
    cp -R . "$out/Applications/Hex Fiend.app"
  '';

  meta = with lib; {
    description = "Open-source macOS hex editor";
    homepage = "http://hexfiend.com/";
    changelog = "https://hexfiend.github.io/HexFiend/ReleaseNotes.html";
    license = licenses.bsd2;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ eliandoran ];
    platforms = platforms.darwin;
  };
}
