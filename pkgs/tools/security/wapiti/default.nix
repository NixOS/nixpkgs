{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wapiti";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "wapiti-scanner";
    repo = pname;
    rev = version;
    sha256 = "0wnz4nq1q5y74ksb1kcss9vdih0kbrmnkfbyc2ngd9id1ixfamxb";
  };

  nativeBuildInputs = with python3.pkgs; [
    pytest-runner
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    browser-cookie3
    Mako
    markupsafe
    pysocks
    requests
    six
    tld
    yaswfp
  ] ++ lib.optionals (python3.pythonOlder "3.8") [ importlib-metadata ];

  checkInputs = with python3.pkgs; [
    responses
    pytestCheckHook
  ];

  postPatch = ''
    # Is already fixed in the repo. Will be part of the next release
    substituteInPlace setup.py \
      --replace "importlib_metadata==2.0.0" "importlib_metadata"
  '';

  disabledTests = [
    # Tests requires network access
    "test_attr"
    "test_bad_separator_used"
    "test_blind"
    "test_chunked_timeout"
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
    "test_url_detection"
    "test_warning"
    "test_whole"
    "test_xss_inside_tag_input"
    "test_xss_inside_tag_link"
    "test_xss_uppercase_no_script"
    "test_xss_with_strong_csp"
    "test_xss_with_weak_csp"
    "test_xxe"
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
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
