{stdenv, fetchurl, saneBackends, saneFrontends,
	libX11, gtk, pkgconfig, libusb ? null}:
stdenv.mkDerivation {
  name = "xsane-0.97";

  src = fetchurl {
    url = ftp://ftp.sane-project.org/pub/sane/xsane/xsane-0.97.tar.gz;
    md5 = "3d1f889d88c3462594febd53be58c561";
  };

  buildInputs = [saneBackends saneFrontends libX11 gtk pkgconfig ] ++
	(if (libusb != null) then [libusb] else []);
}
