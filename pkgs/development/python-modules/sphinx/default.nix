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
, whoosh
, imagesize
, requests
, sphinxcontrib-applehelp
, sphinxcontrib-devhelp
, sphinxcontrib-htmlhelp
, sphinxcontrib-jsmath
, sphinxcontrib-qthelp
, sphinxcontrib-serializinghtml
, sphinxcontrib-websupport
, typing
, setuptools
}:

buildPythonPackage rec {
  pname = "sphinx";
  version = "2.2.2";
  src = fetchPypi {
    pname = "Sphinx";
    inherit version;
    sha256 = "1wjcm382824rq8ijls9mlqwl2h8l26s201v5fwprhnins671m72m";
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
    whoosh
    imagesize
    requests
    sphinxcontrib-applehelp
    sphinxcontrib-devhelp
    sphinxcontrib-htmlhelp
    sphinxcontrib-jsmath
    sphinxcontrib-qthelp
    sphinxcontrib-serializinghtml
    sphinxcontrib-websupport
  ] ++ lib.optional (pythonOlder "3.5") typing;

  # Lots of tests. Needs network as well at some point.
  doCheck = false;

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
