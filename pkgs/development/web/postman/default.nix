{ stdenvNoCC, callPackage, lib }:

let
  pname = "postman";
<<<<<<< HEAD
  version = "10.15.0";
=======
  version = "10.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://www.getpostman.com";
    description = "API Development Environment";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.postman;
    platforms = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ johnrichardrinehart evanjs tricktron Crafter ];
  };

in

if stdenvNoCC.isDarwin
then callPackage ./darwin.nix { inherit pname version meta; }
else callPackage ./linux.nix { inherit pname version meta; }
