{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, ply
, pytestCheckHook
, pythonOlder
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "stone";
  version = "3.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "stone";
    rev = "refs/tags/v${version}";
    hash = "sha256-0FWdYbv+paVU3Wj6g9OrSNUB0pH8fLwTkhVIBPeFB/U=";
  };

  postPatch = ''
    # https://github.com/dropbox/stone/issues/288
    substituteInPlace stone/frontend/ir_generator.py \
      --replace-fail "inspect.getargspec" "inspect.getfullargspec"
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner == 5.2.0'," ""
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    ply
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  disabledTests = [
    "test_type_name_with_module"
  ];

  pythonImportsCheck = [
    "stone"
  ];

  meta = with lib; {
    description = "Official Api Spec Language for Dropbox";
    homepage = "https://github.com/dropbox/stone";
    changelog = "https://github.com/dropbox/stone/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
    mainProgram = "stone";
  };
}
