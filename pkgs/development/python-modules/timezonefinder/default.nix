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
  version = "6.5.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jannikmi";
    repo = "timezonefinder";
    rev = "refs/tags/${version}";
    hash = "sha256-KVjAK4r+cRrX7U6MT0P7hH/TX6kMDv2DaSa456YG4sA=";
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
