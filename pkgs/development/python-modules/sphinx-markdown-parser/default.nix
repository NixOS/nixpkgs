{
  lib,
  stdenv,
  buildPythonPackage,
  commonmark,
  fetchFromGitHub,
  markdown,
  pydash,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  recommonmark,
  setuptools,
  sphinx,
  unify,
  yapf,
}:

buildPythonPackage rec {
  pname = "sphinx-markdown-parser";
  version = "0.2.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

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

  meta = with lib; {
    description = "Write markdown inside of docutils & sphinx projects";
    homepage = "https://github.com/clayrisser/sphinx-markdown-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen ];
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
  };
}
