{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "tendo";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = "tendo";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZOozMGxAKcEtmUEzHCFSojKc+9Ha+T2MOTmMvdMqNuQ=";
  };

  postPatch = ''
    # marken broken and not required
    sed -i '/setuptools_scm_git_archive/d' pyproject.toml
    # unused
    substituteInPlace setup.cfg \
      --replace-fail "six" ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tendo" ];

  meta = with lib; {
    description = "Adds basic functionality that is not provided by Python";
    homepage = "https://github.com/pycontribs/tendo";
    changelog = "https://github.com/pycontribs/tendo/releases/tag/v${version}";
    license = licenses.psfl;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
