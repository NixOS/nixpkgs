{ fetchFromGitHub, stdenv, ncurses, autoreconfHook, SDL2, SDL2_mixer }:

stdenv.mkDerivation rec {
  version = "2016-05-08";
  name = "liberal-crime-squad-${version}";

  src = fetchFromGitHub {
    owner = "Kamal-Sadek";
    repo = "Liberal-Crime-Squad";
    rev = "127d712";
    sha256 = "1n16rmi2gm2mcnpp0ms1whj0nzcbfw52dnd90l52w4d1g4kqf1ck";
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
