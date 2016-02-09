{ stdenv, fetchFromGitHub, pkgconfig, ncurses }:

stdenv.mkDerivation rec {
  name = "progress-${version}";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "Xfennec";
    repo = "progress";
    rev = "v${version}";
    sha256 = "0xzpcvz4n0h8m0mhxgpvn1qg8993naip3asjbk3nmk3d4lbyh0b3";
  };

  nativeBuildInputs = [ pkgconfig ];
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
