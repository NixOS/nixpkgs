{ lib
, attrs
, buildPythonPackage
, entry-points-txt
, fetchFromGitHub
, hatchling
, headerparser
, jsonschema
, pythonRelaxDepsHook
, packaging
, pytestCheckHook
, pythonOlder
, readme-renderer
, setuptools
, wheel-filename
}:

buildPythonPackage rec {
  pname = "wheel-inspect";
  version = "1.7.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = "wheel-inspect";
    rev = "refs/tags/v${version}";
    hash = "sha256-pB9Rh+A7GlxnYuka2mTSBoxpoyYCzoaMPVgsHDlpos0=";
  };

  postPatch = ''
    substituteInPlace tox.ini \
      --replace-fail "--cov=wheel_inspect --no-cov-on-fail" ""
  '';

  pythonRelaxDeps = [
    "entry-points-txt"
    "headerparser"
  ];

  nativeBuildInputs = [
    hatchling
    pythonRelaxDepsHook
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
  ];

  checkInputs = [
    setuptools
    jsonschema
  ];

  pythonImportsCheck = [
    "wheel_inspect"
  ];

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
