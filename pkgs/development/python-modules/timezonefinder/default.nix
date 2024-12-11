{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cffi,
  h3,
  numba,
  numpy,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "timezonefinder";
  version = "6.5.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jannikmi";
    repo = "timezonefinder";
    rev = "refs/tags/${version}";
    hash = "sha256-8fDKgM6LVe7aJgD4UfTpg0EjKGuudzYsmqniocozmAE=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  nativeBuildInputs = [ cffi ];

  dependencies = [
    cffi
    h3
    numpy
  ];

  nativeCheckInputs = [
    numba
    pytestCheckHook
  ];

  pythonImportsCheck = [ "timezonefinder" ];

  preCheck = ''
    # Some tests need the CLI on the PATH
    export PATH=$out/bin:$PATH
  '';

  meta = with lib; {
    changelog = "https://github.com/jannikmi/timezonefinder/blob/${version}/CHANGELOG.rst";
    description = "Module for finding the timezone of any point on earth (coordinates) offline";
    homepage = "https://github.com/MrMinimal64/timezonefinder";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "timezonefinder";
  };
}
