{ lib
, buildPythonPackage
, fetchPypi
, pytest
, simplejson
, mock
, glibcLocales
, html5lib
, pythonOlder
, enum34
, python
, docutils
, jinja2
, pygments
, alabaster
, Babel
, snowballstemmer
, six
, sqlalchemy
, whoosh
, imagesize
, requests
, typing
, sphinxcontrib-websupport
, setuptools
}:

buildPythonPackage rec {
  pname = "sphinx";
  version = "1.8.5";
  src = fetchPypi {
    pname = "Sphinx";
    inherit version;
    sha256 = "c7658aab75c920288a8cf6f09f244c6cfdae30d82d803ac1634d9f223a80ca08";
  };
  LC_ALL = "en_US.UTF-8";

  checkInputs = [ pytest ];
  buildInputs = [ simplejson mock glibcLocales html5lib ] ++ lib.optional (pythonOlder "3.4") enum34;
  # Disable two tests that require network access.
  checkPhase = ''
    cd tests; ${python.interpreter} run.py --ignore py35 -k 'not test_defaults and not test_anchors_ignored'
  '';
  propagatedBuildInputs = [
    docutils
    jinja2
    pygments
    alabaster
    Babel
    setuptools
    snowballstemmer
    six
    sphinxcontrib-websupport
    sqlalchemy
    whoosh
    imagesize
    requests
  ] ++ lib.optional (pythonOlder "3.5") typing;

  # Lots of tests. Needs network as well at some point.
  doCheck = false;

  patches = [
    # Since pygments 2.5, PythonLexer refers to python3. If we want to use
    # python2, we need to explicitly specify Python2Lexer.
    # Not upstreamed since there doesn't seem to be any upstream maintenance
    # branch for 1.8 (and this patch doesn't make any sense for 2.x).
    ./python2-lexer.patch
  ];
  # https://github.com/NixOS/nixpkgs/issues/22501
  # Do not run `python sphinx-build arguments` but `sphinx-build arguments`.
  postPatch = ''
    substituteInPlace sphinx/make_mode.py --replace "sys.executable, " ""
  '';

  meta = {
    description = "A tool that makes it easy to create intelligent and beautiful documentation for Python projects";
    homepage = http://sphinx.pocoo.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nand0p ];
  };
}
