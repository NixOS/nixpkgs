{stdenv, fetchurl, saneBackends, libX11, gtk,
	pkgconfig, libusb ? null}:
stdenv.mkDerivation {
  name = "sane-frontend";

  src = fetchurl {
    url = ftp://ftp.sane-project.org/pub/sane/sane-frontends-1.0.14/sane-frontends-1.0.14.tar.gz;
    md5 = "c63bf7b0bb5f530cf3c08715db721cd3";
  };

  preConfigure = ''
    sed -e '/SANE_CAP_ALWAYS_SETTABLE/d' -i src/gtkglue.c
  '';

  buildInputs = [saneBackends libX11 gtk pkgconfig] ++ 
	(if (libusb != null) then [libusb] else []);
}
