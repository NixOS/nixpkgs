{ stdenvNoCC, callPackage, lib }:

let
  pname = "postman";
  version = "9.14.0";
  meta = with lib; {
    homepage = "https://www.getpostman.com";
    description = "API Development Environment";
    license = licenses.postman;
    platforms = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ johnrichardrinehart evanjs tricktron ];
  };

in

if stdenvNoCC.isDarwin
then callPackage ./darwin.nix { inherit pname version meta; }
else callPackage ./linux.nix { inherit pname version meta; }
