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
, typed-ast
}:

buildPythonPackage rec {
  pname = "sphinx";
  version = "7.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = "sphinx";
    rev = "refs/tags/v${version}";
    postFetch = ''
      cd $out
      mv tests/roots/test-images/testimäge.png tests/roots/test-images/testimæge.png
      patch -p1 < ${./0001-test-images-Use-normalization-equivalent-character.patch}
    '';
    hash = "sha256-bjQQLCUPMU3qZPQ3OMA+CxHh70XywVMMQUK7fIXptgQ=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    babel
    alabaster
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

  nativeCheckInputs = [
    cython
    filelock
    html5lib
    pytestCheckHook
  ] ++ lib.optionals (pythonOlder "3.8") [
    typed-ast
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # requires network access
    "test_anchors_ignored"
    "test_defaults"
    "test_defaults_json"
    "test_latex_images"

    # requires imagemagick (increases build closure size), doesn't
    # test anything substantial
    "test_ext_imgconverter"

    # fails with pygments 2.14
    # TODO remove for sphinx 6
    "test_viewcode"
    "test_additional_targets_should_be_translated"
    "test_additional_targets_should_not_be_translated"

    # sphinx.errors.VersionRequirementError: The alabaster extension
    # used by this project needs at least Sphinx v1.6; it therefore
    # cannot be built with this version.
    "test_needs_sphinx"

    # Likely due to pygments 2.14 update
    #  AssertionError: assert '5:11:17\u202fAM' == '5:11:17 AM'
    "test_format_date"
  ] ++ lib.optionals stdenv.isDarwin [
    # Due to lack of network sandboxing can't guarantee port 7777 isn't bound
    "test_inspect_main_url"
    "test_auth_header_uses_first_match"
    "test_linkcheck_allowed_redirects"
    "test_linkcheck_request_headers"
    "test_linkcheck_request_headers_no_slash"
    "test_follows_redirects_on_HEAD"
    "test_get_after_head_raises_connection_error"
    "test_invalid_ssl"
    "test_connect_to_selfsigned_with_tls_verify_false"
    "test_connect_to_selfsigned_with_tls_cacerts"
    "test_connect_to_selfsigned_with_requests_env_var"
    "test_connect_to_selfsigned_nonexistent_cert_file"
    "test_TooManyRedirects_on_HEAD"
    "test_too_many_requests_retry_after_int_del"
    "test_too_many_requests_retry_after_HTTP_date"
    "test_too_many_requests_retry_after_without_header"
    "test_too_many_requests_user_timeout"
    "test_raises_for_invalid_status"
    "test_auth_header_no_match"
    "test_follows_redirects_on_GET"
    "test_connect_to_selfsigned_fails"
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
