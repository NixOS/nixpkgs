{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  ply,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "stone";
  version = "3.3.6";
  pyproject = true;

  # distutils removal, https://github.com/dropbox/stone/issues/323
  disabled = pythonOlder "3.7" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "stone";
    rev = "refs/tags/v${version}";
    hash = "sha256-Og0hUUCCd9wRdHUhZBl62rDAunP2Bph5COsCw/T1kUA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner == 5.3.2'," ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    ply
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "stone" ];

  meta = with lib; {
    description = "Official Api Spec Language for Dropbox";
    homepage = "https://github.com/dropbox/stone";
    changelog = "https://github.com/dropbox/stone/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
    mainProgram = "stone";
  };
}
