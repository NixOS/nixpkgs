{ stdenv, callPackage, fetchFromGitHub, pugixml, boost }:

let

  NSPlist = callPackage ./nsplist.nix { };
  PlistCpp = callPackage ./plist-cpp.nix { inherit NSPlist; };

in

stdenv.mkDerivation {
  name = "xib2nib-730e177";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "xib2nib";
    rev = "97c6a53aab83d919805efcae33cf80690e953d1e";
    sha256 = "08442f4xg7racknj35nr56a4c62gvdgdw55pssbkn2qq0rfzziqq";
  };

  buildInputs = [ PlistCpp pugixml boost ];
  makeFlags = [ "PREFIX=$(out)" ];
}
