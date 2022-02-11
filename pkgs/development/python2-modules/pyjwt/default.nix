{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, ecdsa
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyjwt";
  version = "1.7.1";

  src = fetchPypi {
    pname = "PyJWT";
    inherit version;
    sha256 = "8d59a976fb773f3e6a39c85636357c4f0e242707394cadadd9814f5cbaa20e96";
  };

  postPatch = ''
    sed -i '/^addopts/d' setup.cfg
  '';

  propagatedBuildInputs = [
    cryptography
    ecdsa
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "test_ec_verify_should_return_false_if_signature_invalid"
  ];

  pythonImportsCheck = [ "jwt" ];

  meta = with lib; {
    description = "JSON Web Token implementation in Python";
    homepage = "https://github.com/jpadilla/pyjwt";
    license = licenses.mit;
  };
}
