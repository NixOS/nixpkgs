{
  lib,
  attrs,
  buildPythonPackage,
  entry-points-txt,
  fetchFromGitHub,
  hatchling,
  headerparser,
  jsonschema,
  packaging,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
  readme-renderer,
  setuptools,
  wheel-filename,
}:

buildPythonPackage rec {
  pname = "wheel-inspect";
  version = "1.7.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = "wheel-inspect";
    tag = "v${version}";
    hash = "sha256-Mdw9IlY/2qDlb5FumNH+VHmg7vrUzo3vn+03QsUGgo8=";
  };

  pythonRelaxDeps = [
    "entry-points-txt"
    "headerparser"
  ];

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    attrs
    entry-points-txt
    headerparser
    packaging
    readme-renderer
    wheel-filename
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  checkInputs = [
    setuptools
    jsonschema
  ];

  pythonImportsCheck = [ "wheel_inspect" ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = with lib; {
    description = "Extract information from wheels";
    mainProgram = "wheel2json";
    homepage = "https://github.com/jwodder/wheel-inspect";
    changelog = "https://github.com/wheelodex/wheel-inspect/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ayazhafiz ];
  };
}
