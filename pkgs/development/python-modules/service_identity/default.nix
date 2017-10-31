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
  version = "17.0.0";
  name = "${pname}-${version}";


  src = fetchPypi {
    inherit pname version;
    sha256 = "4001fbb3da19e0df22c47a06d29681a398473af4aa9d745eca525b3b2c2302ab";
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

  # Tests not included in archive
  doCheck = false;
}