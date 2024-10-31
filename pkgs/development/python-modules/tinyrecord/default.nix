{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  tinydb,
}:

buildPythonPackage rec {
  pname = "tinyrecord";
  version = "0.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "eugene-eeo";
    repo = "tinyrecord";
    rev = "refs/tags/v${version}";
    hash = "sha256-mF4hpHuNyiQ5DurRnyLck5e/Vp26GCLkhD8eeSB4NYs=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    tinydb
  ];

  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [ "tinyrecord" ];

  meta = with lib; {
    description = "Transaction support for TinyDB";
    homepage = "https://github.com/eugene-eeo/tinyrecord";
    changelog = "https://github.com/eugene-eeo/tinyrecord/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
}
