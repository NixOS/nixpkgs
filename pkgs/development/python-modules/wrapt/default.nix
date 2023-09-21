{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, sphinxHook
, sphinx-rtd-theme
}:

buildPythonPackage rec {
  pname = "wrapt";
  version = "1.14.1";
  outputs = [ "out" "doc" ];
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "GrahamDumpleton";
    repo = pname;
    rev = version;
    hash = "sha256-nXwDuNo4yZxgjnkus9bVwIZltPaSH93D+PcZMGT2nGM=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
  ];

  pythonImportsCheck = [
    "wrapt"
  ];

  meta = with lib; {
    description = "Module for decorators, wrappers and monkey patching";
    homepage = "https://github.com/GrahamDumpleton/wrapt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
