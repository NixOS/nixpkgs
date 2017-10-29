{ stdenv, fetchurl, buildPythonPackage, pyusb }:

buildPythonPackage rec {
  name = "usbtmc-${version}";
  version = "0.8";

  src = fetchurl {
    url = "https://github.com/python-ivi/python-usbtmc/archive/v${version}.tar.gz";
    sha256 = "14f4j77ljr45crnjwlp1dqbxwa45s20y2fpq5rg59r60w15al4yw";
  };

  propagatedBuildInputs = [ pyusb ];

  meta = with stdenv.lib; {
    description = "Python implementation of the USBTMC instrument control protocol";
    homepage = http://alexforencich.com/wiki/en/python-usbtmc/start;
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
  };
}
