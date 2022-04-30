{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
# propagatedBuildInputs
, Babel
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
, html5lib
, pytestCheckHook
, typed-ast
}:

buildPythonPackage rec {
  pname = "sphinx";
  version = "4.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Lw9yZWCQpt02SL/McWPcyFRfVhQHC0TejcYRbVw+VxY=";
    extraPostFetch = ''
      cd $out
      mv tests/roots/test-images/testimäge.png \
        tests/roots/test-images/testimæge.png
      patch -p1 < ${./0001-test-images-Use-normalization-equivalent-character.patch}
    '';
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "docutils>=0.14,<0.18" "docutils>=0.14"
  '';

  propagatedBuildInputs = [
    Babel
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
  ] ++ lib.optional stdenv.isDarwin [
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
