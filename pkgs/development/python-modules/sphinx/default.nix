{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, isPyPy

# nativeBuildInputs
, flit-core

# propagatedBuildInputs
, babel
, alabaster
, docutils
, imagesize
, importlib-metadata
, jinja2
, packaging
, pygments
, requests
, snowballstemmer
, sphinxcontrib-apidoc
, sphinxcontrib-applehelp
, sphinxcontrib-devhelp
, sphinxcontrib-htmlhelp
, sphinxcontrib-jsmath
, sphinxcontrib-qthelp
, sphinxcontrib-serializinghtml
, sphinxcontrib-websupport

# check phase
, cython
, filelock
, html5lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sphinx";
  version = "7.0.1";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = pname;
    rev = "refs/tags/v${version}";
    postFetch = ''
      # Change ä to æ in file names, since ä can be encoded multiple ways on different
      # filesystems, leading to different hashes on different platforms.
      cd "$out";
      mv tests/roots/test-images/{testimäge,testimæge}.png
      sed -i 's/testimäge/testimæge/g' tests/{test_build*.py,roots/test-images/index.rst}
    '';
    hash = "sha256-DUUdHvmuxWw06ycH6qFE2LZ9GTzOqdvdPnye8cvVBOQ=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    alabaster
    babel
    docutils
    imagesize
    jinja2
    packaging
    pygments
    requests
    snowballstemmer
    sphinxcontrib-applehelp
    sphinxcontrib-devhelp
    sphinxcontrib-htmlhelp
    sphinxcontrib-jsmath
    sphinxcontrib-qthelp
    sphinxcontrib-serializinghtml
    # extra[docs]
    sphinxcontrib-websupport

    # extra plugins which are otherwise not found by sphinx-build
    sphinxcontrib-apidoc
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    cython
    filelock
    html5lib
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = lib.optionals isPyPy [
    # PyPy has not __builtins__ which get asserted
    # https://doc.pypy.org/en/latest/cpython_differences.html#miscellaneous
    "test_autosummary_generate_content_for_module"
    "test_autosummary_generate_content_for_module_skipped"
    # internals are asserted which are sightly different in PyPy
    "test_autodoc_inherited_members_None"
    "test_automethod_for_builtin"
    "test_builtin_function"
    "test_cython"
    "test_isattributedescriptor"
    "test_methoddescriptor"
    "test_partialfunction"
  ];

  meta = with lib; {
    description = "Python documentation generator";
    longDescription = ''
      A tool that makes it easy to create intelligent and beautiful
      documentation for Python projects
    '';
    homepage = "https://www.sphinx-doc.org";
    license = licenses.bsd3;
    maintainers = teams.sphinx.members;
  };
}
