{ stdenv, fetchurl, perl, perlXMLParser, gettext }:
let
  s = # Generated upstream information
  rec {
    baseName="intltool";
    version="0.50.2";
    name="intltool-0.50.2";
    hash="01j4yd7i84n9nk4ccs6yifg84pp68nr9by57jdbhj7dpdxf5rwk7";
    url="https://launchpad.net/intltool/trunk/0.50.2/+download/intltool-0.50.2.tar.gz";
    sha256="01j4yd7i84n9nk4ccs6yifg84pp68nr9by57jdbhj7dpdxf5rwk7";
  };
  propagatedBuildInputs = [perl perlXMLParser];
  buildInputs = [];
  in
stdenv.mkDerivation {
  inherit (s) name version;
  src = fetchurl {
    inherit (s) url sha256;
  };
  inherit buildInputs;

  # not needed by intltool itself but (probably) needed for its usage
  propagatedBuildInputs = propagatedBuildInputs ++ [ gettext ];

  meta = {
    description = "Translation helper tool";
    homepage = "http://launchpad.net/intltool/";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    inherit (s) version;
  };
}
