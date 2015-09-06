{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "progress-${version}";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "Xfennec";
    repo = "progress";
    rev = "v${version}";
    sha256 = "07bl5fsr538nk4l8vwj1kf5bivlh3a8cy8jliqfadxmhf1knn2mw";
  };

  buildInputs = [ ncurses ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Xfennec/progress;
    description = "Tool that shows the progress of coreutils programs";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
