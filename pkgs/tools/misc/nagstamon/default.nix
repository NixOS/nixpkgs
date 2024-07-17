{
  lib,
  fetchurl,
  pythonPackages,
}:

pythonPackages.buildPythonApplication rec {
  pname = "nagstamon";
  version = "3.14.0";

  src = fetchurl {
    url = "https://github.com/HenriWahl/Nagstamon/archive/refs/tags/v${version}.tar.gz";
    sha256 = "sha256-9RxQ/rfvoyjSUsY4tmAkBdVQqZYi3X6PBzQYFIeenzA=";
  };

  # Test assumes darwin
  doCheck = false;

  build-system = with pythonPackages; [ setuptools ];
  dependencies = with pythonPackages; [
    configparser
    pyqt6
    psutil
    requests
    beautifulsoup4
    keyring
    requests-kerberos
    lxml
    dbus-python
    python-dateutil
    pysocks
  ];

  meta = with lib; {
    description = "Status monitor for the desktop";
    homepage = "https://nagstamon.de/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      pSub
      liberodark
    ];
  };
}
