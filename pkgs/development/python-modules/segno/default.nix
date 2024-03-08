{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, setuptools

# dependencies
, importlib-metadata

# tests
, pytestCheckHook
, pypng
, pyzbar
}:

buildPythonPackage rec {
  pname = "segno";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "heuer";
    repo = "segno";
    rev = "refs/tags/${version}";
    hash = "sha256-5CDrQhbgUydz1ORp4ktZwhcgbJxQq1snKIAA0v4mZ00=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pypng
    pyzbar
  ];

  disabledTests = [
    # https://github.com/heuer/segno/issues/132
    "test_plugin"
  ];

  pythonImportsCheck = [
    "segno"
  ];

  meta = with lib; {
    changelog = "https://github.com/heuer/segno/releases/tag/${version}";
    description = "QR Code and Micro QR Code encoder";
    homepage = "https://github.com/heuer/segno/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ phaer ];
  };
}
