{ stdenv, fetchFromGitHub, cmake, boost, NSPlist, pugixml }:

stdenv.mkDerivation {
  name = "plistcpp-11615d";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "PlistCpp";
    rev = "11615deab3369356a182dabbf5bae30574967264";
    sha256 = "10jn6bvm9vn6492zix2pd724v5h4lccmkqg3lxfw8r0qg3av0yzv";
  };

  buildInputs = [ cmake boost NSPlist pugixml ];
}
