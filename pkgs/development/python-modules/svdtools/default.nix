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
  version = "0.1.22";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-5zMuCFCvh7BXr9BbyyDhWw1Lt/Fomv0SALiPJQbxJNQ=";
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
