{ fetchgit, stdenv, love, curl, zip }:

stdenv.mkDerivation rec {
  version = "0.12.1";
  name = "hawkthorne-${version}";

  src = fetchgit {
    url = "https://github.com/hawkthorne/hawkthorne-journey.git";
    rev = "610b9b3907b2a1b21da2ae926e4c7c4c9e19959b";
    sha256 = "0n2fkk34wr3kyzfhz2mbrzn94vjivblqk2xaid5mj7ls0ymxbmgd";
  };

  buildInputs = [
    love curl zip
  ];

  patches = [
    ./makefile.patch
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Journey to the Center of Hawkthorne - A fan-made retro-style game based on the show Community";
    longDescription = ''
      Journey to the Center of Hawkthorne is an open source game written in Love2D.
      It's based on the show Community, starring Jim Rash and Joel McHale as
      the primary will-they-or-won't-they relationship.

      This game has been entirely developed by fans of the show, who were inspired
      to bring to life the video game used to determine the winner of Pierce
      Hawthorne's inheritance.
    '';
    homepage = "http://www.reddit.com/r/hawkthorne";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ campadrenalin ];
  };
}
