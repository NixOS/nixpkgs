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
  version = "0.1.20";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version pname;
    sha256 = "028s1bn50mfpaygf1wc2mvf06s50wqfplqrkhrjz6kx8vzrmwj72";
  };

  propagatedBuildInputs = [
    braceexpand
    click
    pyyaml
    lxml
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "svdtools" ];

  meta = with lib; {
    description = "Python package to handle vendor-supplied, often buggy SVD files";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
