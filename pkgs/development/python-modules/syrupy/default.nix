{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  poetry-core,
  pytest,
  invoke,
}:

buildPythonPackage rec {
  pname = "syrupy";
  version = "4.7.2";
  pyproject = true;

  disabled = lib.versionOlder python.version "3.8.1";

  src = fetchFromGitHub {
    owner = "syrupy-project";
    repo = "syrupy";
    rev = "refs/tags/v${version}";
    hash = "sha256-akYUsstepkDrRXqp1DY6wEeXMMlLNcCqitnWpjcAurg=";
  };

  build-system = [ poetry-core ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    invoke
    pytest
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
