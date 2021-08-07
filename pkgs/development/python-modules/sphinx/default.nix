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
  version = "4.0.2";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0QdgHFX4r40BDHjpi9R40lXqT4n5ZgrIny+w070LZPE=";
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
