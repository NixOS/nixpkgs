{ stdenv, lib, fetchurl, undmg, nix-update-script }:

let
  urlSuffix = version: if lib.versions.patch == 0 then
    lib.versions.majorMinor version
  else
    version
  ;
in
stdenv.mkDerivation rec {
  pname = "hexfiend";
  version = "2.17.1";

  src = fetchurl {
    url = "https://github.com/HexFiend/HexFiend/releases/download/v${version}/Hex_Fiend_${urlSuffix version}.dmg";
    hash = "sha256-QpGmpxDpdS+sJtsNtp0VSAd9WJXaZiKTH4yDsDK8FSk=";
  };

  sourceRoot = "Hex Fiend.app";
  nativeBuildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/Hex Fiend.app"
    cp -R . "$out/Applications/Hex Fiend.app"
  '';

  passthru.updateScript = nix-update-script { };

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
