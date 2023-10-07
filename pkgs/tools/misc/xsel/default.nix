{ stdenv, lib, fetchFromGitHub, libX11, autoreconfHook }:

stdenv.mkDerivation {
  pname = "xsel-unstable";
  version = "2020-05-27";

  src = fetchFromGitHub {
    owner = "kfish";
    repo = "xsel";
    rev = "062e6d373537c60829fa9b5dcddbcd942986b3c3";
    sha256 = "0fbf80zsc22vcqp59r9fdx4icxhrkv7l3lphw83326jrmkzy6kri";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libX11 ];

  meta = with lib; {
    description = "Command-line program for getting and setting the contents of the X selection";
    homepage = "http://www.kfish.org/software/xsel";
    license = licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
