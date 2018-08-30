{ stdenv, fetchFromGitHub, pkgconfig, ncurses, which }:

stdenv.mkDerivation rec {
  name = "progress-${version}";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "Xfennec";
    repo = "progress";
    rev = "v${version}";
    sha256 = "1lk2v4b767klib93an4g3f7z5qrv9kdk9jf7545vw1immc4kamrl";
  };

  nativeBuildInputs = [ pkgconfig which ];
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
