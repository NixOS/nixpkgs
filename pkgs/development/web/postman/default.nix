{ stdenvNoCC, callPackage, lib }:

let
  pname = "postman";
  version = "9.25.2";
  meta = with lib; {
    homepage = "https://www.getpostman.com";
    description = "API Development Environment";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.postman;
    platforms = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ johnrichardrinehart evanjs tricktron Crafter ];
  };

in

if stdenvNoCC.isDarwin
then callPackage ./darwin.nix { inherit pname version meta; }
else callPackage ./linux.nix { inherit pname version meta; }
