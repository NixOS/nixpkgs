{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "ion-${version}";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "redox-os";
    repo = "ion";
    rev = version;
    sha256 = "0c2haw9qiwysyp1xj6qla8d6zpsdlygagzh86sk04c2b4ssyaca3";
  };

  depsSha256 = "0w2jgbrcx57js8ihzs5acp6b1niw1c7khdxrv14y3z9mmm9j55hs";

  meta = with stdenv.lib; {
    description = "Modern system shell with simple (and powerful) syntax";
    homepage = https://github.com/redox-os/ion;
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
