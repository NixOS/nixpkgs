{ stdenv, lib, fetchurl }:

let
  version = "3.1.1";
  src =
    if stdenv.hostPlatform.system == "x86_64-darwin" then
      fetchurl {
        url = "https://update.tabnine.com/${version}/x86_64-apple-darwin/TabNine";
        sha256 = "w+Ufy4pICfQmseKCeohEQIP0VD6YrkYTEn41HX40Zlw=";
      }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://update.tabnine.com/${version}/x86_64-unknown-linux-musl/TabNine";
        sha256 = "hSltZWQz2BRFut0NDI4fS/N8XxFJaYGHRtV3llBVOY4=";
      }
    else throw "Not supported on ${stdenv.hostPlatform.system}";
in stdenv.mkDerivation rec {
  pname = "tabnine";

  inherit version src;

  dontBuild = true;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    ln -s $src $out/bin/TabNine
  '';

  meta = with lib; {
    homepage = "https://tabnine.com";
    description = "Smart Compose for code that uses deep learning to help you write code faster";
    license = licenses.unfree;
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };
}
