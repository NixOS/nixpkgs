{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
  pytest-rerunfailures,
}:

buildPythonPackage rec {
  pname = "travispy";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "menegazzo";
    repo = "travispy";
    tag = "v${version}";
    hash = "sha256-jYuRaKtoWaWq6QWinXnuBfqanTCMibouwwWHfcmioGo=";
  };

  postPatch = ''
    # Fix deprecated pytest configuration
    substituteInPlace setup.cfg \
      --replace-fail "[pytest]" "[tool:pytest]"
  '';

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-rerunfailures
  ];

  tests = [
    "travispy/_tests/"
  ];

  # Skip tests that require network access
  disabledTests = [
    "test_not_authenticated"
  ];

  pythonImportsCheck = [ "travispy" ];

  meta = {
    description = "Python API for Travis CI";
    homepage = "https://github.com/menegazzo/travispy";
    changelog = "https://github.com/menegazzo/travispy/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
