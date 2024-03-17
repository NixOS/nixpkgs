{ lib, fetchurl, darwin }:

# This cannot be built from source due to the problematic nature of XCode - so
# this is what it's like when doves cry?

darwin.installBinaryPackage rec {
  pname = "MonitorControl";
  version = "4.2.0";

  src = fetchurl {
    url =
      "https://github.com/MonitorControl/${pname}/releases/download/v${version}/MonitorControl.${version}.dmg";
    sha256 = "Q96uK6wVe1D2uLvWL+pFR6LcmrU7cgmr2Y5tPvvTDgI=";
  };

  appName = "MonitorControl.app";

  meta = with lib; {
    description = "A macOS system extension to control brightness and volume of external displays with native OSD";
    longDescription = "Controls your external display brightness and volume and shows native OSD. Use menulet sliders or the keyboard, including native Apple keys!";
    homepage = "https://github.com/MonitorControl/MonitorControl#readme";
    license = licenses.mit;
    maintainers = with maintainers; [ cbleslie cottand ];
  };
}
