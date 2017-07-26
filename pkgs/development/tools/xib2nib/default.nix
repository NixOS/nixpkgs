{ stdenv, callPackage, fetchFromGitHub, pugixml, boost, PlistCpp }:

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

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ matthewbauer ];
    description = "Compiles CocoaTouch .xib files into .nib";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
