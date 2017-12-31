{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "i7z-93";

  src = fetchFromGitHub {
    owner  = "ajaiantilal";
    repo   = "i7z";
    rev    = "5023138d7c35c4667c938b853e5ea89737334e92";
    sha256 = "0z0aqj79cbwwx3q600nwf3nixgihvcngrgkcn1xw6wpl9rpxpzjk";
  };

  # The GUI is qt4 only so we do not build it as qt4 is deprecated

  buildInputs = [ ncurses ];

  enableParallelBuilding = true;

  postPatch = ''
    sed -i Makefile -e "s,^prefix.*,prefix = $out,"
  '';

  meta = with stdenv.lib; {
    description = "A better i3, i5 and i7 reporting tool for Linux";
    homepage = https://github.com/ajaiantilal/i7z;
    repositories.git = https://github.com/ajaiantilal/i7z.git;
    license = licenses.gpl2;
    maintainers = with maintainers; [ bluescreen303 ];
    platforms = platforms.linux;
  };
}
