{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sphinx,
  sphinx-pytest,
  pytestCheckHook,
}:
let
  pname = "sphinx-sitemap";
  version = "2.5.1";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jdillard";
    repo = "sphinx-sitemap";
    rev = "refs/tags/v${version}";
    hash = "sha256-R8nAaEPd2vQs9Z0Fa5yvTP0KP3O+DnIJLPeISZ10Xtk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ sphinx ];

  nativeCheckInputs = [
    pytestCheckHook
    sphinx-pytest
  ];

  meta = with lib; {
    changelog = "https://github.com/jdillard/sphinx-sitemap/releases/tag/v${version}";
    description = "Sitemap generator for Sphinx";
    homepage = "https://github.com/jdillard/sphinx-sitemap";
    maintainers = with maintainers; [ alejandrosame ];
    license = licenses.mit;
  };
}
