{ stdenv, fetchurl, perl, perlXMLParser, gettext }:
let
  s = # Generated upstream information
  rec {
    baseName="intltool";
    version="0.51.0";
    name="${baseName}-${version}";
    hash="1karx4sb7bnm2j67q0q74hspkfn6lqprpy5r99vkn5bb36a4viv7";
    url="https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz";
    sha256="1karx4sb7bnm2j67q0q74hspkfn6lqprpy5r99vkn5bb36a4viv7";
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
    platforms = stdenv.lib.platforms.unix;
    inherit (s) version;
  };
}
