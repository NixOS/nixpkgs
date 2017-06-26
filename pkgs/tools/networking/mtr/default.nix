{stdenv, fetchurl, autoreconfHook, pkgconfig, ncurses
, withGtk ? false, gtk2 ? null}:

assert withGtk -> gtk2 != null;

with stdenv.lib;
stdenv.mkDerivation rec {
  baseName="mtr";
  version="0.87";
  name="${baseName}-${version}";

  src = fetchurl {
    url="ftp://ftp.bitwizard.nl/${baseName}/${name}.tar.gz";
    sha256 = "17zi99n8bdqrwrnbfyjn327jz4gxx287wrq3vk459c933p34ff8r";
  };

  preConfigure = "substituteInPlace Makefile.in --replace ' install-exec-hook' ''";

  configureFlags = optionalString (!withGtk) "--without-gtk";

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ ncurses ] ++ optional withGtk gtk2;

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.bitwizard.nl/mtr/;
    description = "A network diagnostics tool";
    maintainers = with maintainers; [ koral orivej raskin ];
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
