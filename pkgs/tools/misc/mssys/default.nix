{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "ms-sys-2.1.3";
  
  src = fetchurl {
    url = mirror://sourceforge/ms-sys/ms-sys-2.1.3.tgz;
    sha256 = "05djdqp7gqfrfb4czrmbgxgd8qr0h3781gzqvsp3qhfx6ay37z0p";
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
