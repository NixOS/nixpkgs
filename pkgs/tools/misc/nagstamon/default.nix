{ lib, fetchurl, pythonPackages, qt6 }:

pythonPackages.buildPythonApplication rec {
  pname = "nagstamon";
  version = "3.16.0";

  src = fetchurl {
    url = "https://github.com/HenriWahl/Nagstamon/archive/refs/tags/v${version}.tar.gz";
    sha256 = "sha256-zqa2/1mkh6Cv7TguQiNq9AGlTa7mHxlpBfgCBpoKU5Y=";
  };

  # Test assumes darwin
  doCheck = false;

  buildInputs = [ qt6.qtmultimedia qt6.qtbase qt6.qtsvg ];

  build-system = with pythonPackages; [ setuptools ];
  dependencies = with pythonPackages; [ arrow configparser pyqt6 psutil requests
     beautifulsoup4 keyring requests-kerberos lxml dbus-python python-dateutil pysocks ];

  # Use wrapQtAppsHook to wrap the app properly
  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  meta = with lib; {
    description = "Status monitor for the desktop";
    homepage = "https://nagstamon.de/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub liberodark ];
  };
}
