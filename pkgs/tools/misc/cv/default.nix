{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "cv-${version}";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Xfennec";
    repo = "cv";
    rev = "v${version}";
    sha256 = "1dcq45mz443mzzf344ap5dgsazhcrn3aislxs57jqbg4p5bbmh1b";
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
