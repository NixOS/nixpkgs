{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "procps-ng-3.3.10";
  
  src = fetchurl {
    url = "mirror://sourceforge/procps-ng/Production/${name}.tar.xz";
    sha256 = "0d8mki0q4yamnkk4533kx8mc0jd879573srxhg6r2fs3lkc6iv8i";
  };

  buildInputs = [ ncurses ];

  makeFlags = "DESTDIR=$(out)";

  crossAttrs = {
    CC = stdenv.cross.config + "-gcc";
  };

  meta = {
    homepage = http://procps.sourceforge.net/;
    description = "Utilities that give information about processes using the /proc filesystem";
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
