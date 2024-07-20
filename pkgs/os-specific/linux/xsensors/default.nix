{ stdenv, lib, fetchurl, gtk2, pkg-config, lm_sensors }:

stdenv.mkDerivation rec {
  pname = "xsensors";
  version = "0.70";
  src = fetchurl {
    url = "http://www.linuxhardware.org/xsensors/xsensors-${version}.tar.gz";
    sha256 = "1siplsfgvcxamyqf44h71jx6jdfmvhfm7mh0y1q8ps4zs6pj2zwh";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk2 lm_sensors
  ];
  patches = [
    ./remove-unused-variables.patch
    ./replace-deprecated-gtk.patch
  ];
  meta = with lib; {
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
