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
  version = "5.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sloria";
    repo = "sphinx-issues";
    tag = version;
    hash = "sha256-/nc5gtZbE1ziMPWIkZTkevMfVkNtJYL/b5QLDeMhzUs=";
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
