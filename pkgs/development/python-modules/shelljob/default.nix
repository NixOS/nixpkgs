{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "shelljob";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "mortoray";
    repo = "shelljob";
    rev = "refs/tags/v${version}";
    hash = "sha256-UJ8DcQaYUiZMZ4hh2juQ/HUwY4LtH6GDjZWioNnfBmw=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    cd test
  '';

  # These assume FHS
  disabledTests = [
    "test_basic"
    "test_example"
  ];

  pythonImportsCheck = [ "shelljob" ];

  meta = {
    description = "Provides a clean way to execute subprocesses, either one or multiple in parallel, capture their output and monitor progress";
    homepage = "https://github.com/mortoray/shelljob";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gamedungeon ];
  };
}
