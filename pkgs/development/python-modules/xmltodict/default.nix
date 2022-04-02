{ lib
, buildPythonPackage
, fetchPypi
, coverage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "xmltodict";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21";
  };

  checkInputs = [ coverage pytestCheckHook ];

  disabledTests = [
    # incompatibilities with security fixes: https://github.com/martinblech/xmltodict/issues/289
    "test_namespace_collapse"
    "test_namespace_support"
  ];

  meta = {
    description = "Makes working with XML feel like you are working with JSON";
    homepage = "https://github.com/martinblech/xmltodict";
    license = lib.licenses.mit;
  };
}
