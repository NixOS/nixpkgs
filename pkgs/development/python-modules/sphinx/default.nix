{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
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
, html5lib
, pytestCheckHook
, typed-ast
}:

buildPythonPackage rec {
  pname = "sphinx";
  version = "5.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kdwznYvs4szhC+qoL2Zsib9cU69fag1KhCXl8qIGkZU=";
    postFetch = ''
      cd $out
      mv tests/roots/test-images/testimäge.png \
        tests/roots/test-images/testimæge.png
      patch -p1 < ${./0001-test-images-Use-normalization-equivalent-character.patch}
    '';
  };

  patches = [
    # https://github.com/sphinx-doc/sphinx/pull/10624
    (fetchpatch {
      name = "avoid-deprecated-docutils-0.19-api.patch";
      sha256 = "sha256-QIrLkxnexNcfuI00UOeCpAamMLqqt4wxoVY1VA72jIw=";
      url = "https://github.com/sphinx-doc/sphinx/commit/8d99168794ab8be0de1e6281d1b76af8177acd3d.patch";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "docutils>=0.14,<0.19" "docutils>=0.14"

    # remove impurity caused by date inclusion
    # https://github.com/sphinx-doc/sphinx/blob/master/setup.cfg#L4-L6
    substituteInPlace setup.cfg \
      --replace "tag_build = .dev" "" \
      --replace "tag_date = true" ""
  '';

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
