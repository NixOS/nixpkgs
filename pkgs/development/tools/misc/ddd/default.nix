{lib, stdenv, fetchurl, motif, ncurses, libX11, libXt, libXft, libXaw}:

stdenv.mkDerivation rec {
  pname = "ddd";
  version = "3.4.1";
  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-uHUXpsP5YRVmNH4oOiz5Mfo2mRm1U1NqIjXmNAL07ok=";
  };
  buildInputs = [motif ncurses libX11 libXt libXft libXaw];

  postInstall = ''
    install -D icons/ddd.xpm $out/share/pixmaps/ddd.xpm
  '';

  meta = {
    homepage = "https://www.gnu.org/software/ddd";
    description = "Graphical front-end for command-line debuggers";
    mainProgram = "ddd";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ emilytrau ];
  };
}
