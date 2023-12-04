{ lib
, stdenv
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
  version = "7.2.6";
  format = "pyproject";
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = "sphinx";
    rev = "refs/tags/v${version}";
    postFetch = ''
      # Change ä to æ in file names, since ä can be encoded multiple ways on different
      # filesystems, leading to different hashes on different platforms.
      cd "$out";
      mv tests/roots/test-images/{testimäge,testimæge}.png
      sed -i 's/testimäge/testimæge/g' tests/{test_build*.py,roots/test-images/index.rst}
    '';
    hash = "sha256-IjpRGeGpGfzrEvwIKtuu2l1S74w8W+AbqDOGnWwtRck=";
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

  disabledTests = [
    # requires network access
    "test_latex_images"
    # racy
    "test_defaults"
    "test_check_link_response_only"
    "test_anchors_ignored_for_url"
    "test_autodoc_default_options"
  ] ++ lib.optionals isPyPy [
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

  meta = {
    description = "Python documentation generator";
    longDescription = ''
      Sphinx makes it easy to create intelligent and beautiful documentation.

      Here are some of Sphinx’s major features:
      - Output formats: HTML (including Windows HTML Help), LaTeX (for printable
        PDF versions), ePub, Texinfo, manual pages, plain text
      - Extensive cross-references: semantic markup and automatic links for
        functions, classes, citations, glossary terms and similar pieces of
        information
      - Hierarchical structure: easy definition of a document tree, with
        automatic links to siblings, parents and children
      - Automatic indices: general index as well as a language-specific module
        indices
      - Code handling: automatic highlighting using the Pygments highlighter
      - Extensions: automatic testing of code snippets, inclusion of docstrings
        from Python modules (API docs) via built-in extensions, and much more
        functionality via third-party extensions.
      - Themes: modify the look and feel of outputs via creating themes, and
        re-use many third-party themes.
      - Contributed extensions: dozens of extensions contributed by users; most
        of them installable from PyPI.

      Sphinx uses the reStructuredText markup language by default, and can read
      MyST markdown via third-party extensions. Both of these are powerful and
      straightforward to use, and have functionality for complex documentation
      and publishing workflows. They both build upon Docutils to parse and write
      documents.
    '';
    homepage = "https://www.sphinx-doc.org";
    changelog = "https://www.sphinx-doc.org/en/master/changes.html";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.sphinx.members;
  };
}
