{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "progress-${version}";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "Xfennec";
    repo = "progress";
    rev = "v${version}";
    sha256 = "0lwj0zdcdsl1wczk3yq7wfpyw3zi87h8x2z8yjp0wgnr45bbqibl";
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
