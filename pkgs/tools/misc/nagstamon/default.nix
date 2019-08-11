{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "nagstamon-${version}";
  version = "3.2.1";

  src = fetchurl {
    url = "https://nagstamon.ifw-dresden.de/files/stable/Nagstamon-${version}.tar.gz";
    sha256 = "1048x55g3nlyyggn6a36xmj24w4hv08llg58f4hzc0fwg074cd58";
  };

  # Test assumes darwin
  doCheck = false;

  propagatedBuildInputs = with pythonPackages; [ configparser pyqt5 psutil requests
     beautifulsoup4 keyring requests-kerberos kerberos lxml ];

  meta = with stdenv.lib; {
    description = "A status monitor for the desktop";
    homepage = https://nagstamon.ifw-dresden.de/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    inherit version;
  };
}
