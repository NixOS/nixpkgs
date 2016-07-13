{ fetchFromGitHub, stdenv, ncurses, autoreconfHook, SDL2, SDL2_mixer }:

stdenv.mkDerivation rec {
  version = "2016-07-06";
  name = "liberal-crime-squad-${version}";

  src = fetchFromGitHub {
    owner = "Kamal-Sadek";
    repo = "Liberal-Crime-Squad";
    rev = "2ace84e";
    sha256 = "0mcldn8ivlfyjfx22ygzcbbw3bzl0j6vi3g6jyj8jmcrni61mgmb";
  };

  buildInputs = [ ncurses autoreconfHook SDL2 SDL2_mixer ];

  meta = with stdenv.lib; {
    description = "A humorous politically themed ncurses game";
    longDescription = ''
      Welcome to Liberal Crime Squad! The Conservatives have taken the Executive, Legislative, and Judicial branches of government. Over time, the Liberal laws of this nation will erode and turn the country into a BACKWOODS YET CORPORATE NIGHTMARE. To prevent this from happening, the Liberal Crime Squad was established. The mood of the country is shifting, and we need to turn things around. Go out on the streets and indoctrinate Conservative automatons. That is, let them see their True Liberal Nature. Then arm them and send them forth to Stop Evil.
    '';
    homepage = https://github.com/Kamal-Sadek/Liberal-Crime-Squad;
    maintainers = [ maintainers.rardiol ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
