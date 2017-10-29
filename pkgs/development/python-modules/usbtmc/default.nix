{ stdenv, fetchurl, buildPythonPackage, pyusb }:

buildPythonPackage rec {
  name = "usbtmc-${version}";
  version = "0.6";

  src = fetchurl {
    url = "https://github.com/python-ivi/python-usbtmc/archive/v${version}.tar.gz";
    sha256 = "1wnw6ndc3s1i8zpbikz5zc40ijvpraqdb0xn8zmqlyn95xxfizw2";
  };

  propagatedBuildInputs = [ pyusb ];

  meta = with stdenv.lib; {
    description = "Python implementation of the USBTMC instrument control protocol";
    homepage = http://alexforencich.com/wiki/en/python-usbtmc/start;
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
  };
}
