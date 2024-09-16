{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wapiti";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wapiti-scanner";
    repo = "wapiti";
    rev = "refs/tags/${version}";
    hash = "sha256-Ekh31MXqxY6iSyQRX0YZ0Tl7DFhYqGtOepYS/VObZc0=";
  };

  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [ setuptools ];

  dependencies =
    with python3.pkgs;
    [
      aiocache
      aiohttp
      aiosqlite
      arsenic
      beautifulsoup4
      browser-cookie3
      dnspython
      h11
      httpcore
      httpx
      httpx-ntlm
      humanize
      loguru
      mako
      markupsafe
      mitmproxy
      prance
      pyasn1
      six
      sqlalchemy
      tld
      yaswfp
    ]
    ++ httpx.optional-dependencies.brotli
    ++ httpx.optional-dependencies.socks
    ++ prance.optional-dependencies.osv;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = with python3.pkgs; [
    respx
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # Tests requires network access
    "test_attr"
    "test_bad_separator_used"
    "test_blind"
    "test_chunked_timeout"
    "test_cookies_detection"
    "test_cookies"
    "test_csrf_cases"
    "test_detection"
    "test_direct"
    "test_dom_detection"
    "test_drop_cookies"
    "test_escape_with_style"
    "test_explorer_extract_links"
    "test_explorer_filtering"
    "test_false"
    "test_frame"
    "test_headers_detection"
    "test_html_detection"
    "test_implies_detection"
    "test_inclusion_detection"
    "test_merge_with_and_without_redirection"
    "test_meta_detection"
    "test_multi_detection"
    "test_no_crash"
    "test_options"
    "test_out_of_band"
    "test_partial_tag_name_escape"
    "test_prefix_and_suffix_detection"
    "test_qs_limit"
    "test_rare_tag_and_event"
    "test_redirect_detection"
    "test_request_object"
    "test_save_and_restore_state"
    "test_script"
    "test_ssrf"
    "test_swagger_parser"
    "test_tag_name_escape"
    "test_timeout"
    "test_title_false_positive"
    "test_title_positive"
    "test_true_positive_request_count"
    "test_unregistered_cname"
    "test_url_detection"
    "test_verify_dns"
    "test_vulnerabilities"
    "test_warning"
    "test_whole"
    "test_xss_inside_tag_input"
    "test_xss_inside_tag_link"
    "test_xss_uppercase_no_script"
    "test_xss_with_strong_csp"
    "test_xss_with_weak_csp"
    "test_xxe"
    # Requires a PHP installation
    "test_cookies"
    "test_fallback_to_html_injection"
    "test_loknop_lfi_to_rce"
    "test_open_redirect"
    "test_redirect"
    "test_timesql"
    "test_xss_inside_href_link"
    "test_xss_inside_src_iframe"
    # TypeError: Expected bytes or bytes-like object got: <class 'str'>
    "test_persister_upload"
    # Requires creating a socket to an external URL
    "test_attack_unifi"
  ];

  disabledTestPaths = [
    # Requires sslyze which is obsolete and was removed
    "tests/attack/test_mod_ssl.py"
  ];

  pythonImportsCheck = [ "wapitiCore" ];

  meta = with lib; {
    description = "Web application vulnerability scanner";
    longDescription = ''
      Wapiti allows you to audit the security of your websites or web applications.
      It performs "black-box" scans (it does not study the source code) of the web
      application by crawling the webpages of the deployed webapp, looking for
      scripts and forms where it can inject data. Once it gets the list of URLs,
      forms and their inputs, Wapiti acts like a fuzzer, injecting payloads to see
      if a script is vulnerable.
    '';
    homepage = "https://wapiti-scanner.github.io/";
    changelog = "https://github.com/wapiti-scanner/wapiti/blob/${version}/doc/ChangeLog_Wapiti";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
