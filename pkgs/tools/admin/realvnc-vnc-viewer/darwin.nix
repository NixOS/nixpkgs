{ lib
, stdenvNoCC
, fetchurl
, undmg
, pname
, version
, meta
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version meta;

  src = fetchurl {
    url = "https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-${finalAttrs.version}-MacOSX-universal.dmg";
    sha256 = "0k72fdnx1zmyi9z5n3lazc7s70gcddxq0s73akp0al0y9hzq9prh";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';
})
