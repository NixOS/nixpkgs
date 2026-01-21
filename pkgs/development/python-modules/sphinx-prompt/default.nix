{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
  poetry-dynamic-versioning,

  # dependencies
  docutils,
  pygments,
  sphinx,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinx-prompt";
  version = "1.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sbrunner";
    repo = "sphinx-prompt";
    tag = version;
    hash = "sha256-ut1g4Clq8mVUYwCe0XMt4GIXUJ4Hy7k8DjWbR7GJ8Bg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    docutils
    pygments
    sphinx
  ];

  # upstream pins these unnecessarily in their requirements.txt
  pythonRelaxDeps = [
    "certifi"
    "requests"
    "urllib3"
    "zipp"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Sphinx extension for creating unselectable prompt";
    homepage = "https://github.com/sbrunner/sphinx-prompt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
