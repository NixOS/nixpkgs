{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "nagstamon-${version}";
  version = "2.0.1";

  src = fetchurl {
    url = "https://nagstamon.ifw-dresden.de/files/stable/Nagstamon-${version}.tar.gz";
    sha256 = "3d4b22190d47250b175a4a70b12391c694ba2399832320887e5909e1ce3dfd7b";
  };

  # Test assumes darwin
  doCheck = false;

  propagatedBuildInputs = with pythonPackages; [ configparser pyqt5 psutil requests
     beautifulsoup4  ];

  meta = with stdenv.lib; {
    description = "A status monitor for the desktop";
    homepage = https://nagstamon.ifw-dresden.de/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    inherit version;
  };
}
