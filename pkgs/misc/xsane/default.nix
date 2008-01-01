{stdenv, fetchurl, saneBackends, saneFrontends,
	libX11, gtk, pkgconfig, libusb ? null}:
stdenv.mkDerivation {
  name = "xsane-0.995";

  src = fetchurl {
    url = ftp://ftp.sane-project.org/pub/sane/xsane/xsane-0.995.tar.gz;
    sha256 = "02rl5bkk3z3k6s04ki14l12vsl5jnx4mri66m1hl799m7hjl5836";
  };

  buildInputs = [saneBackends saneFrontends libX11 gtk pkgconfig ] ++
	(if (libusb != null) then [libusb] else []);
}
