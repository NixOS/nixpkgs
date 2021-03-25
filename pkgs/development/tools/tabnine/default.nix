{ stdenv, lib, fetchurl, unzip }:

let
  version = "3.2.63";
  src =
    if stdenv.hostPlatform.system == "x86_64-darwin" then
      fetchurl {
        url = "https://update.tabnine.com/bundles/${version}/x86_64-apple-darwin/TabNine.zip";
        sha256 = "0y0wb3jdr2qk4k21c11w8c9a5fl0h2rm1wm7m8hqdywy4lz9ppgy";
      }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://update.tabnine.com/bundles/${version}/x86_64-unknown-linux-musl/TabNine.zip";
        sha256 = "0zzk2w5azk5f0svjxlj2774x01xdflb767xxvbglj4223dgyx2x5";
      }
    else throw "Not supported on ${stdenv.hostPlatform.system}";
in stdenv.mkDerivation rec {
  pname = "tabnine";

  inherit version src;

  dontBuild = true;

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  setSourceRoot = "sourceRoot=`pwd`";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    install -Dm755 TabNine $out/bin/TabNine
  '';

  meta = with lib; {
    homepage = "https://tabnine.com";
    description = "Smart Compose for code that uses deep learning to help you write code faster";
    license = licenses.unfree;
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };
}
