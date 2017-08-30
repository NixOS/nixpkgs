{ lib
, buildPythonPackage
, fetchPypi
, characteristic
, pyasn1
, pyasn1-modules
, pyopenssl
, idna
, attrs
, pytest
}:

buildPythonPackage rec {
  pname = "service_identity";
  version = "16.0.0";
  name = "${pname}-${version}";


  src = fetchPypi {
    inherit pname version;
    sha256 = "0dih7i7d36nbllcxgfkvbnaj1wlzhwfnpr4b97dz74czylif4c06";
  };

  propagatedBuildInputs = [
    characteristic pyasn1 pyasn1-modules pyopenssl idna attrs
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    py.test
  '';
}