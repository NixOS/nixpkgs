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

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-5zMuCFCvh7BXr9BbyyDhWw1Lt/Fomv0SALiPJQbxJNQ=";
  };

  # remove upon next release
  # see: https://github.com/stm32-rs/svdtools/pull/96
  prePatch = ''
    substituteInPlace setup.py \
      --replace 'PyYAML ~= 5.3' 'PyYAML >= 5.3'
  '';

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
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-python.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
