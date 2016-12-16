{ stdenv, fetchFromGitHub, pkgconfig, ncurses, which }:

stdenv.mkDerivation rec {
  name = "progress-${version}";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "Xfennec";
    repo = "progress";
    rev = "v${version}";
    sha256 = "13nhczzb0zqg5zfpf5vcfi6aahyb8lrr52pvpjgi1zfkh2m9vnig";
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
