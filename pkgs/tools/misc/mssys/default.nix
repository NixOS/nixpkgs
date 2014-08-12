{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "ms-sys-2.1.3";
  
  src = fetchurl {
    url = mirror://sourceforge/ms-sys/ms-sys-2.1.3.tgz;
    md5 = "6fad0a69ac89440ad4f696dbbbf11497";
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
