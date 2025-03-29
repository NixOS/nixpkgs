{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest,
  pytest-xdist,
  invoke,
}:

buildPythonPackage rec {
  pname = "syrupy";
  version = "4.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "syrupy-project";
    repo = "syrupy";
    tag = "v${version}";
    hash = "sha256-AK4cB7MiL52oRUV6ArNj94srMsEpk/YQdjJ5tnjrAYM=";
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
    changelog = "https://github.com/syrupy-project/syrupy/blob/${src.tag}/CHANGELOG.md";
    description = "Pytest Snapshot Test Utility";
    homepage = "https://github.com/syrupy-project/syrupy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
