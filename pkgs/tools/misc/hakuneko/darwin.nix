{ fetchurl
, stdenv
, lib
, undmg
, src
, pname
, version
, meta
, desktopName
}:
stdenv.mkDerivation rec {
  inherit pname version src meta desktopName;

  nativeBuildInputs = [
    undmg
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r "${desktopName}.app" "$out/Applications/"

    runHook postInstall
  '';

}
