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
  version = "6.5.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jannikmi";
    repo = "timezonefinder";
    tag = version;
    hash = "sha256-Jo3sOFbmy+NKPL0+21rZQUXIC9WpVT1D3X2sxTC89jY=";
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
    changelog = "https://github.com/jannikmi/timezonefinder/blob/${src.tag}/CHANGELOG.rst";
    description = "Module for finding the timezone of any point on earth (coordinates) offline";
    homepage = "https://github.com/MrMinimal64/timezonefinder";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "timezonefinder";
  };
}
