{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  dom-toml,
  whey,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "whey-pth";
  version = "0.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "repo-helper";
    repo = "whey-pth";
    tag = "v${version}";
    hash = "sha256-A+bXB9F8FD+A1iRuETIxP12bkH/5NKcx01ERXJZAj+Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'setuptools!=61.*,<=67.1.0,>=40.6.0' setuptools
  '';

  build-system = [ setuptools ];

  dependencies = [
    dom-toml
    whey
  ];

  pythonImportsCheck = [ "whey_pth" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # missing dependency coincidence
  doCheck = false;

  meta = {
    description = "Extension to whey to support .pth files";
    homepage = "https://github.com/repo-helper/whey-pth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
