{stdenv, fetchurl, ncurses, autoconf
, withGtk ? false, gtk2 ? null}:

assert withGtk -> gtk2 != null;

with stdenv.lib;
stdenv.mkDerivation rec {
  baseName="mtr";
  version="0.86";
  name="${baseName}-${version}";
  
  src = fetchurl {
    url="ftp://ftp.bitwizard.nl/${baseName}/${name}.tar.gz";
    sha256 = "01lcy89q3i9g4kz4liy6m7kcq1zyvmbc63rqidgw67341f94inf5";
  };

  configureFlags = optionalString (!withGtk) "--without-gtk";

  buildInputs = [ autoconf ncurses ] ++ optional withGtk gtk2;

  meta = {
    homepage = http://www.bitwizard.nl/mtr/;
    description = "A network diagnostics tool";
    maintainers = [ maintainers.koral maintainers.raskin ];
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}

