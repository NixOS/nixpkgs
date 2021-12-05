{ lib, buildPythonPackage, pythonOlder, fetchFromGitHub
# propagatedBuildInputs
, Babel, alabaster, docutils, imagesize, jinja2, packaging, pygments, requests
, setuptools, snowballstemmer, sphinxcontrib-applehelp, sphinxcontrib-devhelp
, sphinxcontrib-htmlhelp, sphinxcontrib-jsmath, sphinxcontrib-qthelp
, sphinxcontrib-serializinghtml, sphinxcontrib-websupport
# check phase
, html5lib, pytestCheckHook, typed-ast }:

buildPythonPackage rec {
  pname = "sphinx";
  version = "4.2.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i38n5bxqiycjwmiv9dl72r3f5ks4zmif30znqg8zilclbx6g16x";
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

  checkInputs = [ html5lib pytestCheckHook ]
    ++ lib.optionals (pythonOlder "3.8") [ typed-ast ];

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
