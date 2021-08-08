{ lib, stdenv, fetchurl, makeWrapper, curl }:

stdenv.mkDerivation {
  pname = "ix";
  version = "20190815";

  src = fetchurl {
    url = "http://ix.io/client";
    sha256 =  "0xc2s4s1aq143zz8lgkq5k25dpf049dw253qxiav5k7d7qvzzy57";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    install -Dm +x $src $out/bin/ix
  '';

  postFixup = ''
    wrapProgram $out/bin/ix --prefix PATH : "${lib.makeBinPath [ curl ]}"
  '';

  meta = with lib; {
    homepage = "http://ix.io";
    description = "Command line pastebin";
    maintainers = with maintainers; [ asymmetric ];
    platforms = platforms.all;
  };
}
