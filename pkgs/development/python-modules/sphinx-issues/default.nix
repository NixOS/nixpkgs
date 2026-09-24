{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  sphinx,
}:
buildPythonPackage rec {
  pname = "sphinx-issues";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sloria";
    repo = "sphinx-issues";
    tag = version;
    hash = "sha256-havy1wP300yAKRi68fAVfQS7t5S9NueuGqE2RqdkVP0=";
  };

  postPatch = ''
    substituteInPlace tests/test_sphinx_issues.py \
      --replace-fail 'Path(sys.executable).parent.joinpath("sphinx-build")' '"${lib.getExe' sphinx "sphinx-build"}"'
  '';

  build-system = [ flit-core ];

  dependencies = [ sphinx ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sphinx_issues" ];

  meta = {
    homepage = "https://github.com/sloria/sphinx-issues";
    description = "Sphinx extension for linking to your project's issue tracker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
