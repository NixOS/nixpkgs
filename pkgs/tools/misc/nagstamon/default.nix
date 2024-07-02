{ lib, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "nagstamon";
  version = "3.14.0";

  src = fetchurl {
    url = "https://github.com/HenriWahl/Nagstamon/archive/refs/tags/v${version}.tar.gz";
    sha256 = "f51c50feb7efa328d252c638b6602405d550a99622dd7e8f07341814879e9f30";
  };

  # Test assumes darwin
  doCheck = false;

  propagatedBuildInputs = with pythonPackages; [ configparser pyqt5 psutil requests
     beautifulsoup4 keyring requests-kerberos kerberos lxml ];

  meta = with lib; {
    description = "Status monitor for the desktop";
    homepage = "https://nagstamon.de/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ liberodark ];
    # fails to install with:
    # TypeError: cannot unpack non-iterable bool object
    broken = false;
  };
}
