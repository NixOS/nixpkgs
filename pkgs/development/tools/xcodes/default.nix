{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcodes";
  version = "1.4.1";

  src = fetchurl {
    url = "https://github.com/XcodesOrg/xcodes/releases/download/${finalAttrs.version}/xcodes.zip";
    hash = "sha256-PtXF2eqNfEX29EtXlcjdxrUs7BPn/YurUuFFeLpXwrk=";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    runHook preUnpack
    unzip -q $src
    runHook postUnpack
  '';

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 xcodes $out/bin/xcodes
    runHook postInstall
  '';

  dontFixup = true;

  meta = with lib; {
    changelog = "https://github.com/XcodesOrg/xcodes/releases/tag/${finalAttrs.version}";
    description = "Command-line tool to install and switch between multiple versions of Xcode";
    homepage = "https://github.com/XcodesOrg/xcodes";
    license = licenses.mit;
    maintainers = with maintainers; [ _0x120581f ];
    platforms = platforms.darwin;
  };
})
