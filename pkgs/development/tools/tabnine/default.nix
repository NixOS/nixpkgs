{ stdenv, lib, fetchurl, unzip }:

let
  version = "3.3.115";
  src =
    if stdenv.hostPlatform.system == "x86_64-darwin" then
      fetchurl
        {
          url = "https://update.tabnine.com/bundles/${version}/x86_64-apple-darwin/TabNine.zip";
          sha256 = "104h3b9cvmz2m27a94cfc00xm8wa2p1pvrfs92hrz59hcs8vdldf";
        }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl
        {
          url = "https://update.tabnine.com/bundles/${version}/x86_64-unknown-linux-musl/TabNine.zip";
          sha256 = "0rs2vmdz8c9zs53pjbzy27ir0p5v752cpsnqfaqf0ilx7k6fpnnm";
        }
    else throw "Not supported on ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation rec {
  pname = "tabnine";

  inherit version src;

  dontBuild = true;

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  setSourceRoot = "sourceRoot=`pwd`";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    install -Dm755 TabNine $out/bin/TabNine
    install -Dm755 TabNine-deep-cloud $out/bin/TabNine-deep-cloud
    install -Dm755 TabNine-deep-local $out/bin/TabNine-deep-local
    install -Dm755 WD-TabNine $out/bin/WD-TabNine
  '';

  meta = with lib; {
    homepage = "https://tabnine.com";
    description = "Smart Compose for code that uses deep learning to help you write code faster";
    license = licenses.unfree;
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };
}
