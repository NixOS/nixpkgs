{ lib
, buildPythonPackage
, fetchPypi
, httpx
, lxml
, pyparsing
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "twill";
  version = "3.2.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m4jrxx7udWkRXzYS0Yfd14tKVHt8kGYPn2eTa4unOdc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    httpx
    lxml
    pyparsing
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "twill"
  ];

  meta = with lib; {
    description = "A simple scripting language for Web browsing";
    homepage = "https://twill-tools.github.io/twill/";
    changelog = "https://github.com/twill-tools/twill/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
