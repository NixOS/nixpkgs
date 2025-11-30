{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sphinx,
  sphinx-last-updated-by-git,
  sphinx-pytest,
  defusedxml,
  pytestCheckHook,
}:
let
  pname = "sphinx-sitemap";
  version = "2.9.0";
in
buildPythonPackage rec {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jdillard";
    repo = "sphinx-sitemap";
    tag = "v${version}";
    hash = "sha256-TiR6F9wMWOGYexSKDzbSPPq0oiIDrZwSiO3a9DajL+0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    sphinx
    sphinx-last-updated-by-git
  ];

  nativeCheckInputs = [
    pytestCheckHook
    sphinx-pytest
    defusedxml
  ];

  meta = with lib; {
    changelog = "https://github.com/jdillard/sphinx-sitemap/releases/tag/${src.tag}";
    description = "Sitemap generator for Sphinx";
    homepage = "https://github.com/jdillard/sphinx-sitemap";
    maintainers = with maintainers; [ alejandrosame ];
    license = licenses.mit;
  };
}
