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
    rev = "636fe783e8625bbdd7bfeaf85470ba3eb7b90359";
    sha256 = "08fhx8rww95h1fpl1cwhd82bcqv1k51k542v4kawjf8w814g5y1c";
  };

  buildInputs = [ PlistCpp pugixml boost ];
  makeFlags = [ "PREFIX=$(out)" ];
}
