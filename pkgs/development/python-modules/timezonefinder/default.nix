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
  version = "6.5.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jannikmi";
    repo = "timezonefinder";
    rev = "refs/tags/${version}";
    hash = "sha256-2vQk7aSsyyh3mN1l4A5Y5yASJ2V7e4fegsOExGwyhGA=";
  };

  nativeBuildInputs = [
    cffi
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [
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
    mainProgram = "timezonefinder";
    homepage = "https://github.com/MrMinimal64/timezonefinder";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
