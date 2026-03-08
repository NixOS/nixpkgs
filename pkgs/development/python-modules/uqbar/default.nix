{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-asyncio,
  pythonAtLeast,
  defusedxml,
  setuptools,
  sphinx,
  typing-extensions,
  unidecode,
}:

buildPythonPackage (finalAttrs: {
  pname = "uqbar";
  version = "0.9.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supriya-project";
    repo = "uqbar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1rK40lwZ3YmQZXhia2+iYRZxDCYvijXgBMIL5p7KmR0=";
  };

  postPatch = ''
    sed -i  pyproject.toml \
    -e '/"black"/d' \
    -e "/--cov/d"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    unidecode
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  checkInputs = [
    defusedxml
    typing-extensions
  ];

  disabledTests = [
    # UnboundLocalError: local variable 'output_path' referenced before assignment
    "test_01"
    # AssertionError: assert False
    "test_sphinx_book_html_cached"
    # FileNotFoundError: [Errno 2] No such file or directory: 'unflatten'
    "test_sphinx_style_html"
    # assert not ["\x1b[91mWARNING: dot command 'dot' cannot be run (needed for
    # graphviz output), check the graphviz_dot setting\x1b[39;49;00m"]
    "test_sphinx_style_latex"
  ]
  ++ lib.optional (pythonAtLeast "3.11") [
    # assert not '\x1b[91m/build/uqbar-0.7.0/tests/fake_package/enums.py:docstring
    "test_sphinx_style"
  ]
  ++ lib.optional (pythonAtLeast "3.12") [
    # https://github.com/supriya-project/uqbar/issues/93
    "objects.get_vars"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # https://github.com/supriya-project/uqbar/issues/106
    "test_04"
    "SummarizingClassDocumenter"
  ];

  pythonImportsCheck = [ "uqbar" ];

  meta = {
    description = "Tools for creating Sphinx and Graphviz documentation";
    homepage = "https://github.com/supriya-project/uqbar";
    changelog = "https://github.com/supriya-project/uqbar/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ davisrichard437 ];
  };
})
