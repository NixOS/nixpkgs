{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "cv-${version}";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "Xfennec";
    repo = "cv";
    rev = "v${version}";
    sha256 = "0nhhgkaghfp8rw23013j17yn9bqcwcrz0fylwkvx1krp5r8dalis";
  };

  buildInputs = [ ncurses ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Xfennec/cv;
    description = "Tool that shows the progress of coreutils programs";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
