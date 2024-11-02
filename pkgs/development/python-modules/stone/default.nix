{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mock,
  packaging,
  ply,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "stone";
  version = "3.3.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "stone";
    rev = "refs/tags/v${version}";
    hash = "sha256-W+wRVWPaAzhdHMVE54GEJC/YJqYZVJhwFDWWSMKUPdw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner == 5.3.2'," ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    ply
    six
    packaging
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
    maintainers = [ ];
    mainProgram = "stone";
  };
}
