{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, braceexpand
, click
, pyyaml
, lxml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "svdtools";
  version = "0.1.23";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-LuursRuUZEDLbk9Wbnq/S0dsZHbzIJo1YCSVFMUoiog=";
  };

  propagatedBuildInputs = [
    braceexpand
    click
    pyyaml
    lxml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "svdtools"
  ];

  meta = with lib; {
    description = "Python package to handle vendor-supplied, often buggy SVD files";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-python.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
