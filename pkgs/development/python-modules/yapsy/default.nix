{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Yapsy";
  version = "1.11.223";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19pjsnqizswnczhlav4lb7zlzs0n73ijrsgksy4374b14jkkkfs5";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://yapsy.sourceforge.net/;
    description = "Yet another plugin system";
    license = licenses.bsd0;
  };

}
