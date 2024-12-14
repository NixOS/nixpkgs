{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  poetry-core,
  pytest,
  pytest-xdist,
  invoke,
}:

buildPythonPackage rec {
  pname = "syrupy";
  version = "4.8.0";
  pyproject = true;

  disabled = lib.versionOlder python.version "3.8.1";

  src = fetchFromGitHub {
    owner = "syrupy-project";
    repo = "syrupy";
    rev = "refs/tags/v${version}";
    hash = "sha256-IifGufCUhjbl8Tqvcjm8XF4QPvOsRacPWxI1yT79eNs=";
  };

  build-system = [ poetry-core ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    invoke
    pytest
    pytest-xdist
  ];

  checkPhase = ''
    runHook preCheck
    # https://github.com/tophat/syrupy/blob/main/CONTRIBUTING.md#local-development
    invoke test
    runHook postCheck
  '';

  pythonImportsCheck = [ "syrupy" ];

  meta = {
    changelog = "https://github.com/syrupy-project/syrupy/blob/${src.rev}/CHANGELOG.md";
    description = "Pytest Snapshot Test Utility";
    homepage = "https://github.com/syrupy-project/syrupy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
