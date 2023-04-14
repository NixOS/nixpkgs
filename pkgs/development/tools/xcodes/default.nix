{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcodes";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/XcodesOrg/xcodes/releases/download/${finalAttrs.version}/xcodes.zip";
    hash = "sha256:0cqb0gfb80xrnm4fipr46kbzqz2kicc13afhdxkbifzm4k83any5";
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
    description = "Command-line tool to install and switch between multiple versions of Xcode";
    homepage = "https://github.com/XcodesOrg/xcodes";
    license = licenses.mit;
    maintainers = with maintainers; [ _0x120581f ];
    platforms = platforms.darwin;
  };
})
