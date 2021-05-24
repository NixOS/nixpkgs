{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
# propagatedBuildInputs
, Babel
, alabaster
, docutils
, imagesize
, jinja2
, packaging
, pygments
, requests
, setuptools
, snowballstemmer
, sphinxcontrib-applehelp
, sphinxcontrib-devhelp
, sphinxcontrib-htmlhelp
, sphinxcontrib-jsmath
, sphinxcontrib-qthelp
, sphinxcontrib-serializinghtml
, sphinxcontrib-websupport
# check phase
, html5lib
, imagemagick
, pytestCheckHook
, typed-ast
}:

buildPythonPackage rec {
  pname = "sphinx";
  version = "3.5.4";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xjii3dl01rq8x2bsxc6zywiy1s7arfgxrg5l8ml54w1748shadd";
  };

  propagatedBuildInputs = [
    Babel
    alabaster
    docutils
    imagesize
    jinja2
    packaging
    pygments
    requests
    setuptools
    snowballstemmer
    sphinxcontrib-applehelp
    sphinxcontrib-devhelp
    sphinxcontrib-htmlhelp
    sphinxcontrib-jsmath
    sphinxcontrib-qthelp
    sphinxcontrib-serializinghtml
    # extra[docs]
    sphinxcontrib-websupport
  ];

  checkInputs = [
    imagemagick
    html5lib
    pytestCheckHook
  ] ++ lib.optionals (pythonOlder "3.8") [
    typed-ast
  ];

  disabledTests = [
    # requires network access
    "test_anchors_ignored"
    "test_defaults"
    "test_defaults_json"
    "test_latex_images"
  ];

  meta = with lib; {
    description = "Python documentation generator";
    longDescription = ''
      A tool that makes it easy to create intelligent and beautiful
      documentation for Python projects
    '';
    homepage = "https://www.sphinx-doc.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
