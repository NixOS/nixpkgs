{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "cv-${version}";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "Xfennec";
    repo = "cv";
    rev = "v${version}";
    sha256 = "17vfcv0n1ib4rh1hdl126aid7cnnk94avzlk9yp7y855iml8xzs4";
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
