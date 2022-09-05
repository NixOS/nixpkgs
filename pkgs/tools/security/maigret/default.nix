{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "maigret";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "soxoj";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-0Ni4rXVu3ZQyHBvD3IpV0i849CnumLj+n6/g4sMhHEs=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    aiodns
    aiohttp
    aiohttp-socks
    arabic-reshaper
    async-timeout
    attrs
    beautifulsoup4
    certifi
    chardet
    colorama
    future
    html5lib
    idna
    jinja2
    lxml
    markupsafe
    mock
    multidict
    networkx
    pycountry
    pypdf2
    pysocks
    python-bidi
    pyvis
    requests
    requests-futures
    six
    socid-extractor
    soupsieve
    stem
    torrequest
    tqdm
    typing-extensions
    webencodings
    xhtml2pdf
    xmind
    yarl
  ];

  checkInputs = with python3.pkgs; [
    pytest-httpserver
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    # Remove all version pinning
    sed -i -e "s/==[0-9.]*//" requirements.txt

    # We are not build for Python < 3.7
    substituteInPlace requirements.txt \
      --replace "future-annotations" ""
  '';

  pytestFlagsArray = [
    # DeprecationWarning: There is no current event loop
    "-W ignore::DeprecationWarning"
  ];

  disabledTests = [
    # Tests require network access
    "test_extract_ids_from_page"
    "test_import_aiohttp_cookies"
    "test_maigret_results"
    "test_pdf_report"
    "test_self_check_db_negative_enabled"
    "test_self_check_db_positive_enable"
  ];

  pythonImportsCheck = [
    "maigret"
  ];

  meta = with lib; {
    description = "Tool to collect details about an username";
    homepage = "https://maigret.readthedocs.io";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
