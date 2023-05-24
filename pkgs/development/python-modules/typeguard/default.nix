{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools-scm
, sphinx-autodoc-typehints
, sphinx-rtd-theme
, sphinxHook
, importlib-metadata
, typing-extensions
, mypy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "typeguard";
  version = "3.0.2";
  format = "pyproject";
  disabled = pythonOlder "3.7";
  outputs = [ "out" "doc" ];

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "typeguard";
    rev = "refs/tags/${version}";
    hash = "sha256-1Cl34HDbAEiTFMMVgYlCv9e6RtwHu7h7PgpCttuCu3c=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
    sphinx-autodoc-typehints
    sphinx-rtd-theme
    sphinxHook
  ];

  propagatedBuildInputs = [
    importlib-metadata
    typing-extensions
  ];

  nativeCheckInputs = [
    mypy
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Run-time type checker for Python";
    homepage = "https://github.com/agronholm/typeguard";
    changelog = "https://github.com/agronholm/typeguard/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
