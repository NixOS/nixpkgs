{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  pytest,
  pytest-xdist,
  invoke,
}:

buildPythonPackage rec {
  pname = "syrupy";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "syrupy-project";
    repo = "syrupy";
    tag = "v${version}";
    hash = "sha256-oogH5Q+0leZsfu/7r3tZmB2rxjcUOmGAsn4Z50oSlH8=";
  };

  build-system = [ poetry-core ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    attrs
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
    changelog = "https://github.com/syrupy-project/syrupy/blob/${src.tag}/CHANGELOG.md";
    description = "Pytest Snapshot Test Utility";
    homepage = "https://github.com/syrupy-project/syrupy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
