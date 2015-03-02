{stdenv, fetchurl, gettext}:

stdenv.mkDerivation rec {
  name = "ms-sys-${version}";
  version = "2.4.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/ms-sys/${name}.tar.gz";
    sha256 = "0qccv67fc2q97218b9wm6qpmx0nc0ssca391i0q15351y1na78nc";
  };

  buildInputs = [gettext];

  preBuild = ''
    makeFlags=(PREFIX=$out)
  '';

  meta = {
    homepage = http://ms-sys.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    description = "A program for writing Microsoft compatible boot records";
  };
}
