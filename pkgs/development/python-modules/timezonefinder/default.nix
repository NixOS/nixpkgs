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
  version = "6.5.9";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jannikmi";
    repo = "timezonefinder";
    tag = version;
    hash = "sha256-LkGDR8nSGfRiBxSXugauGhe3+8RsLRPWU3oE+1c5iCk=";
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-warn '"poetry-core>=1.0.0,<2.0.0"' '"poetry-core>=1.0.0"'
  '';

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
