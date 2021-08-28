{ lib, stdenv, fetchFromGitLab }:

stdenv.mkDerivation rec {
  pname = "bunny";
  version = "1.3";

  src = fetchFromGitLab {
    owner = "tim241";
    repo = "bunny";
    rev = version;
    sha256 = "0nh2h5kj9b0nkb6yrzf4if7anfdmy9vijzy4bl3s7qck0nzbpy8s";
  };

  dontBuild = true;

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "A simple shell script wrapper around multiple package managers";
    homepage = "https://gitlab.com/tim241/bunny";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ buffet ];
  };
}
