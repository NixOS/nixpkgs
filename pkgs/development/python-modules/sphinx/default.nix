{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub

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
, html5lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sphinx";
  version = "6.1.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = pname;
    rev = "refs/tags/v${version}";
    /* One of the test images used a combining character `ä` that can be
       encoded multiple ways. This means the file's name can end up encoded
       differently depending on whether/which normal form the filesystem uses.

       For Nix this causes a different hash for a FOD depending on the
       filesystem where it is evaluated. This is problematic because hashes
       fail to match up when evaluating the FOD across multiple platforms.
    */
    postFetch = ''
      cd $out
      mv tests/roots/test-images/{testimäge,testimæge}.png
      sed -i 's/testimäge/testimæge/g' tests/{test_build*.py,roots/test-images/index.rst}
    '';
    hash = "sha256-ClKAB+oQ0sdV/mssfXEkgpqbzhT3ybXPeqjQjbxqbrY=";
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
    html5lib
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
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
