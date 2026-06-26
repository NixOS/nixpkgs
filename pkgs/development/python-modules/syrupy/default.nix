{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hypothesis,
  pydantic,
  pytest,
  pytest-xdist,
  invoke,
}:

buildPythonPackage (finalAttrs: {
  pname = "syrupy";
  version = "5.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "syrupy-project";
    repo = "syrupy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tivRKADRYyyNmNOOd0w2qTseA3t7TMwkAkQ/Kr6wp6U=";
  };

  build-system = [ hatchling ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    hypothesis
    invoke
    pydantic
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
    changelog = "https://github.com/syrupy-project/syrupy/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Pytest Snapshot Test Utility";
    homepage = "https://github.com/syrupy-project/syrupy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
