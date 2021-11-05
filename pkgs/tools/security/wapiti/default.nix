{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wapiti";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "wapiti-scanner";
    repo = pname;
    rev = version;
    sha256 = "0kya9a2zs1c518z4p34pfjx2sms6843gh3c9qc9zvk4lr4g7hw3x";
  };

  nativeBuildInputs = with python3.pkgs; [
    pytest-runner
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiocache
    aiosqlite
    beautifulsoup4
    browser-cookie3
    cryptography
    dnspython
    httpx
    httpx-ntlm
    httpx-socks
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
      --replace "httpx-socks[asyncio] == 0.5.1" "httpx-socks[asyncio]" \
      --replace "markupsafe==1.1.1" "markupsafe" \
      --replace "importlib_metadata==3.7.2" "importlib_metadata" \
      --replace "browser-cookie3==0.11.4" "browser-cookie3" \
      --replace "cryptography==3.3.2" "cryptography" \
      --replace "httpx[brotli]==0.20.0" "httpx" \
      --replace "sqlalchemy>=1.4.26" "sqlalchemy" \
      --replace "aiocache==0.11.1" "aiocache" \
      --replace "aiosqlite==0.17.0" "aiosqlite" \
      --replace "dnspython==2.1.0" "dnspython"
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
    "test_tag_name_escape"
    "test_timeout"
    "test_title_false_positive"
    "test_title_positive"
    "test_true_positive_request_count"
    "test_unregistered_cname"
    "test_url_detection"
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
    # E           TypeError: Expected bytes or bytes-like object got: <class 'str'>
    "test_persister_upload"
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
