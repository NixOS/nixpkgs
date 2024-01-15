{ lib
, buildPythonPackage
, fetchPypi
, unidecode
, sphinx
, pythonAtLeast
, pythonOlder
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "uqbar";
  version = "0.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cEhWXGtMSXVjT5QigDedjT/lwYQnVqPCE5vbctXWznk=";
  };

  postPatch = ''
    sed -i '/"black"/d' pyproject.toml
  '';

  propagatedBuildInputs = [
    unidecode
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pytestFlagsArray = [
    "tests/"
    "-vv"
    "-rf"
    "--cov-branch"
    "--cov-report=html"
    "--cov-report=term"
    "--doctest-modules"
  ];

  disabledTests = [
    # UnboundLocalError: local variable 'output_path' referenced before
    # assignment
    "test_01"
    # AssertionError: assert False
    "test_sphinx_book_html_cached"
    # FileNotFoundError: [Errno 2] No such file or directory: 'unflatten'
    "test_sphinx_style_html"
    # assert not ["\x1b[91mWARNING: dot command 'dot' cannot be run (needed for
    # graphviz output), check the graphviz_dot setting\x1b[39;49;00m"]
    "test_sphinx_style_latex"
  ]
  # assert not '\x1b[91m/build/uqbar-0.7.0/tests/fake_package/enums.py:docstring
  ++ lib.optional (pythonAtLeast "3.11") "test_sphinx_style";

  pythonImportsCheck = [ "uqbar" ];

  meta = {
    description = "Tools for creating Sphinx and Graphviz documentation";
    license = lib.licenses.mit;
    homepage = "https://github.com/josiah-wolf-oberholtzer/uqbar";
    changelog =
      "https://github.com/josiah-wolf-oberholtzer/uqbar/releases/tag/v${version}";
    maintainers = [ lib.maintainers.davisrichard437 ];
  };
}
