{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
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

  patches = [
    (fetchpatch {
      # Fix tests with pygments 2.10
      url = "https://github.com/sphinx-doc/sphinx/commit/bde6c8d2effc56dc8b9098abee796167f972c306.patch";
      sha256 = "0d0ddhgrrh7z9ix0f3zrc2gjb4d73f6ffm98zl62fzv5l4fd00lr";
    })
  ];

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

    # requires imagemagick (increases build closure size), doesn't
    # test anything substantial
    "test_ext_imgconverter"
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
