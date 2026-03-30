{
  lib,
  buildPythonPackage,
  commonmark,
  fetchFromGitHub,
  markdown,
  pydash,
  pytestCheckHook,
  pyyaml,
  recommonmark,
  setuptools,
  sphinx,
  unify,
  yapf,
}:

buildPythonPackage {
  pname = "sphinx-markdown-parser";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clayrisser";
    repo = "sphinx-markdown-parser";
    # Upstream maintainer currently does not tag releases
    # https://github.com/clayrisser/sphinx-markdown-parser/issues/35
    rev = "2fd54373770882d1fb544dc6524c581c82eedc9e";
    sha256 = "0i0hhapmdmh83yx61lxi2h4bsmhnzddamz95844g2ghm132kw5mv";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    commonmark
    markdown
    pydash
    pyyaml
    recommonmark
    unify
    yapf
  ];

  buildInputs = [ sphinx ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sphinx_markdown_parser" ];

  disabledTests = [
    # AssertionError
    "test_heading"
    "test_headings"
    "test_integration"
  ];

  meta = {
    description = "Write markdown inside of docutils & sphinx projects";
    homepage = "https://github.com/clayrisser/sphinx-markdown-parser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
}
