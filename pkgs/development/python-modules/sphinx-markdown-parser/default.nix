{
  lib,
  buildPythonPackage,
  commonmark,
  docutils,
  fetchFromGitHub,
  markdown,
  pytestCheckHook,
  pyyaml,
  sphinx,
  uv-build,
}:

buildPythonPackage {
  pname = "sphinx-markdown-parser";
  version = "0.2.4-unstable-2026-08-13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clayrisser";
    repo = "sphinx-markdown-parser";
    # Upstream maintainer currently does not tag releases
    # https://github.com/clayrisser/sphinx-markdown-parser/issues/35
    rev = "f7229b8fe778321e192161150e8ad1db75248281";
    hash = "sha256-clMAzCpiRQI03h01j4jWc/5B6zUVqMZaGPxtwKDTXlk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.18,<0.10.0" "uv_build"
  '';

  build-system = [ uv-build ];

  pythonRelaxDeps = [ "sphinx" ];

  dependencies = [
    commonmark
    docutils
    markdown
    pyyaml
    sphinx
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sphinx_markdown_parser" ];

  disabledTests = [
    # fixture was generated with docutils 0.21, newer versions no longer escape quotes
    "test_kitchen_sink"
  ];

  meta = {
    description = "Write markdown inside of docutils & sphinx projects";
    homepage = "https://github.com/clayrisser/sphinx-markdown-parser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
}
