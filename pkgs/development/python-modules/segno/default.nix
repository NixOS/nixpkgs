{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# tests
, pytestCheckHook
, pypng
, pyzbar
}:

buildPythonPackage rec {
  pname = "segno";
  version = "1.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "heuer";
    repo = "segno";
    rev = version;
    hash = "sha256-j7DUCeMoYziu19WfJu/9YiIMa2ysOPYfqW8AMcE5LaU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pypng
    pyzbar
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
