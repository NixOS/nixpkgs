{stdenv, fetchurl, saneBackends, saneFrontends,
	libX11, gtk, pkgconfig, libusb ? null}:
stdenv.mkDerivation {
  name = "xsane-0.996";

  src = fetchurl {
    url = ftp://ftp.sane-project.org/pub/sane/xsane/xsane-0.996.tar.gz;
    sha256 = "0zddar0y76iv4c55qzfmnm819z5hzisr2jwjb60x36v6bdrhcjx5";
  };

  buildInputs = [saneBackends saneFrontends libX11 gtk pkgconfig ] ++
	(if (libusb != null) then [libusb] else []);
}
