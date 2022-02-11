{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wapiti";
  version = "3.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "wapiti-scanner";
    repo = pname;
    rev = version;
    sha256 = "1xyvyan5gz7fz8wa2fbgvma59pr79arqra2gvx861szn2njkf272";
  };

  nativeBuildInputs = with python3.pkgs; [
    pytest-runner
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiocache
    aiosqlite
    beautifulsoup4
    brotli
    browser-cookie3
    cryptography
    dnspython
    httpcore
    httpx
    httpx-ntlm
    httpx-socks
    humanize
    loguru
    Mako
    markupsafe
    pysocks
    six
    sqlalchemy
    tld
    yaswfp
  ] ++ lib.optionals (python3.pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = with python3.pkgs; [
    respx
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    # Ignore pinned versions
    substituteInPlace setup.py \
      --replace "httpx-socks[asyncio] == 0.6.0" "httpx-socks[asyncio]"
    sed -i -e "s/==[0-9.]*//;s/>=[0-9.]*//" setup.py
    substituteInPlace setup.cfg \
      --replace " --cov --cov-report=xml" ""
  '';

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # Tests requires network access
    "test_attr"
    "test_bad_separator_used"
    "test_blind"
    "test_chunked_timeout"
    "test_cookies"
    "test_drop_cookies"
    "test_save_and_restore_state"
    "test_explorer_extract_links"
    "test_cookies_detection"
    "test_csrf_cases"
    "test_detection"
    "test_direct"
    "test_escape_with_style"
    "test_explorer_filtering"
    "test_false"
    "test_frame"
    "test_headers_detection"
    "test_html_detection"
    "test_implies_detection"
    "test_inclusion_detection"
    "test_meta_detection"
    "test_no_crash"
    "test_options"
    "test_out_of_band"
    "test_multi_detection"
    "test_vulnerabilities"
    "test_partial_tag_name_escape"
    "test_prefix_and_suffix_detection"
    "test_qs_limit"
    "test_rare_tag_and_event"
    "test_redirect_detection"
    "test_request_object"
    "test_script"
    "test_ssrf"
    "test_merge_with_and_without_redirection"
    "test_tag_name_escape"
    "test_timeout"
    "test_title_false_positive"
    "test_title_positive"
    "test_true_positive_request_count"
    "test_unregistered_cname"
    "test_url_detection"
    "test_verify_dns"
    "test_warning"
    "test_whole"
    "test_xss_inside_tag_input"
    "test_xss_inside_tag_link"
    "test_xss_uppercase_no_script"
    "test_xss_with_strong_csp"
    "test_xss_with_weak_csp"
    "test_xxe"
    # Requires a PHP installation
    "test_timesql"
    "test_cookies"
    "test_redirect"
    # TypeError: Expected bytes or bytes-like object got: <class 'str'>
    "test_persister_upload"
  ];
  disabledTestPaths = [
    # requires sslyze
    "tests/attack/test_mod_ssl.py"
  ];

  pythonImportsCheck = [
    "wapitiCore"
  ];

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
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
