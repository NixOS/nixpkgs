{ lib, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "nagstamon";
  version = "3.2.1";

  src = fetchurl {
    url = "https://nagstamon.ifw-dresden.de/files/stable/Nagstamon-${version}.tar.gz";
    sha256 = "1048x55g3nlyyggn6a36xmj24w4hv08llg58f4hzc0fwg074cd58";
  };

  # Test assumes darwin
  doCheck = false;

  propagatedBuildInputs = with pythonPackages; [ configparser pyqt5 psutil requests
     beautifulsoup4 keyring requests-kerberos kerberos lxml ];

  meta = with lib; {
    description = "Status monitor for the desktop";
    homepage = "https://nagstamon.ifw-dresden.de/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    # fails to install with:
    # TypeError: cannot unpack non-iterable bool object
    broken = true;
  };
}
