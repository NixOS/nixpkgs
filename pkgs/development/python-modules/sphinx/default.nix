{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  pythonOlder,
  fetchFromGitHub,
  isPyPy,

  # build-system
  flit-core,

  # dependencies
  babel,
  alabaster,
  docutils,
  imagesize,
  importlib-metadata,
  jinja2,
  packaging,
  pygments,
  requests,
  roman-numerals-py,
  snowballstemmer,
  sphinxcontrib-applehelp,
  sphinxcontrib-devhelp,
  sphinxcontrib-htmlhelp,
  sphinxcontrib-jsmath,
  sphinxcontrib-qthelp,
  sphinxcontrib-serializinghtml,
  sphinxcontrib-websupport,
  tomli,

  # check phase
  defusedxml,
  filelock,
  html5lib,
  pytestCheckHook,
  pytest-xdist,
  typing-extensions,

  # reverse dependencies to test
  breathe,
}:

buildPythonPackage rec {
  pname = "sphinx";
  version = "8.2.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = "sphinx";
    tag = "v${version}";
    postFetch = ''
      # Change ä to æ in file names, since ä can be encoded multiple ways on different
      # filesystems, leading to different hashes on different platforms.
      cd "$out";
      mv tests/roots/test-images/{testimäge,testimæge}.png
      sed -i 's/testimäge/testimæge/g' tests/{test_build*.py,roots/test-images/index.rst}
    '';
    hash = "sha256-FoyCpDGDKNN2GMhE7gDpJLmWRWhbMCYlcVEaBTfXSEw=";
  };

  build-system = [ flit-core ];

  dependencies = [
    alabaster
    babel
    docutils
    imagesize
    jinja2
    packaging
    pygments
    requests
    roman-numerals-py
    snowballstemmer
    sphinxcontrib-applehelp
    sphinxcontrib-devhelp
    sphinxcontrib-htmlhelp
    sphinxcontrib-jsmath
    sphinxcontrib-qthelp
    sphinxcontrib-serializinghtml
    # extra[docs]
    sphinxcontrib-websupport
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ]
  ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    defusedxml
    filelock
    html5lib
    pytestCheckHook
    pytest-xdist
    typing-extensions
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
    "test_too_many_requests_retry_after_int_delay"
    # racy with pytest-xdist
    "test_domain_cpp_build_semicolon"
    "test_class_alias"
    "test_class_alias_having_doccomment"
    "test_class_alias_for_imported_object_having_doccomment"
    "test_decorators"
    "test_xml_warnings"
    # racy with too many threads
    # https://github.com/NixOS/nixpkgs/issues/353176
    "test_document_toc_only"
    # Assertion error
    "test_gettext_literalblock_additional"
    # requires cython_0, but fails miserably on 3.11
    "test_cython"
    # Could not fetch remote image: http://localhost:7777/sphinx.png
    "test_copy_images"
    # ModuleNotFoundError: No module named 'fish_licence.halibut'
    "test_import_native_module_stubs"
    # Racy tex file creation
    "test_literalinclude_namedlink_latex"
    "test_literalinclude_caption_latex"
    # Racy local networking
    "test_load_mappings_cache"
    "test_load_mappings_cache_update"
    "test_load_mappings_cache_revert_update"
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    # https://github.com/sphinx-doc/sphinx/issues/12430
    "test_autodoc_type_aliases"
  ]
  ++ lib.optionals isPyPy [
    # PyPy has not __builtins__ which get asserted
    # https://doc.pypy.org/en/latest/cpython_differences.html#miscellaneous
    "test_autosummary_generate_content_for_module"
    "test_autosummary_generate_content_for_module_skipped"
    # internals are asserted which are sightly different in PyPy
    "test_autodoc_inherited_members_None"
    "test_automethod_for_builtin"
    "test_builtin_function"
    "test_isattributedescriptor"
    "test_methoddescriptor"
    "test_partialfunction"
  ];

  passthru.tests = {
    inherit breathe;
  };

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
    teams = [ lib.teams.sphinx ];
  };
}
