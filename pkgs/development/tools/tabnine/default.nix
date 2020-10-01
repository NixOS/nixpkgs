{ stdenv, lib, fetchurl }:

let
  target =
    if stdenv.hostPlatform.system == "x86_64-darwin" then
      "x86_64-apple-darwin"
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      "x86_64-unknown-linux-musl"
    else throw "Not supported on ${stdenv.hostPlatform.system}";
in stdenv.mkDerivation rec {
  pname = "tabnine";
  version = "3.1.1";

  src = fetchurl {
    url = "https://update.tabnine.com/${version}/${target}/TabNine";
    sha256 = "w+Ufy4pICfQmseKCeohEQIP0VD6YrkYTEn41HX40Zlw=";
  };

  dontBuild = true;
  dontUnpack = true;

  installPhase = ''
    chmod +x $src
    mkdir -p $out/bin
    ln -s $src $out/bin/TabNine
  '';

  meta = {
    homepage = "https://tabnine.com";
    description = "Smart Compose for code that uses deep learning to help you write code faster";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };
}
