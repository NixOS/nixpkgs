{lib, stdenv, fetchurl, motif, ncurses, libX11, libXt}:

stdenv.mkDerivation rec {
  pname = "ddd";
  version = "3.3.12";
  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0p5nx387857w3v2jbgvps2p6mlm0chajcdw5sfrddcglsxkwvmis";
  };
  buildInputs = [motif ncurses libX11 libXt];
  configureFlags = [ "--with-x" ];

  patches = [
    # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=504868
    ./gcc44.patch
  ];

  NIX_CFLAGS_COMPILE = "-fpermissive";

  postInstall = ''
    install -D icons/ddd.xpm $out/share/pixmaps/ddd.xpm
  '';

  meta = {
    homepage = "https://www.gnu.org/software/ddd";
    description = "Graphical front-end for command-line debuggers";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ emilytrau ];
  };
}
