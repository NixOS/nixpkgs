{stdenv, fetchurl, saneBackends, saneFrontends,
	libX11, gtk, pkgconfig, libpng, libusb ? null}:
stdenv.mkDerivation {
  name = "xsane-0.998";

  src = fetchurl {
    url = http://www.xsane.org/download/xsane-0.998.tar.gz;
    sha256 = "0vn2cj85ijgp2v2j2h9xpqmg2jwlbxmwyb88kxhjjakqay02ybm3";
  };

  preConfigure = ''
    sed -e '/SANE_CAP_ALWAYS_SETTABLE/d' -i src/xsane-back-gtk.c
  '';

  buildInputs = [libpng saneBackends saneFrontends libX11 gtk pkgconfig ] ++
	(if (libusb != null) then [libusb] else []);

  meta = {
    homepage = http://www.sane-project.org/;
  };
}
