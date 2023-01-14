{ lib
, buildPythonPackage
, fetchFromGitLab
, fetchpatch
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "tololib";
  version = "0.1.0b4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "MatthiasLohr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2OQaJR70bx8qWs1IPErF+B3X1iRvHW74axTqtdvum3U=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Test requires network access
    "test_discovery"
  ];

  pythonImportsCheck = [
    "tololib"
  ];

  meta = with lib; {
    description = "Python Library for Controlling TOLO Sauna/Steam Bath Devices";
    homepage = "https://gitlab.com/MatthiasLohr/tololib";
    changelog = "https://gitlab.com/MatthiasLohr/tololib/-/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
