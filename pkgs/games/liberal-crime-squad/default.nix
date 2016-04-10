{ fetchFromGitHub, stdenv, ncurses, autoconf, automake , SDL2, SDL2_mixer }:

stdenv.mkDerivation rec {
  version = "2016-03-03";
  name = "liberal-crime-squad-${version}";
  src = fetchFromGitHub {
    owner = "Kamal-Sadek";
    repo = "Liberal-Crime-Squad";
    rev = "39c5f167e902e33cb37b152215d67f71b9ae8269";
    sha256 = "18s2w2570fd79y9rb7ikxls1qw29l1lbwk9n2dxxqjslbzrbvv31";
  };

  preConfigure = ''
    ./bootstrap
  '';

  buildInputs = [ ncurses autoconf automake SDL2 SDL2_mixer ];

  meta = with stdenv.lib; {
    description = "A humorous politically themed ncurses game";
    longDescription = ''
      Welcome to Liberal Crime Squad! The Conservatives have taken the Executive, Legislative, and Judicial branches of government. Over time, the Liberal laws of this nation will erode and turn the country into a BACKWOODS YET CORPORATE NIGHTMARE. To prevent this from happening, the Liberal Crime Squad was established. The mood of the country is shifting, and we need to turn things around. Go out on the streets and indoctrinate Conservative automatons. That is, let them see their True Liberal Nature. Then arm them and send them forth to Stop Evil.
    '';
    homepage = https://github.com/Kamal-Sadek/Liberal-Crime-Squad;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
