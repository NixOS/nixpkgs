{ lib
, aiohttp
, aioresponses
, attrs
, buildPythonPackage
, cached-property
, defusedxml
, fetchFromGitHub
, freezegun
, httpx
, isodate
, lxml
, mock
, platformdirs
, pretend
, pytest-asyncio
, pytest-httpx
, pytestCheckHook
, pythonOlder
, pytz
, requests
, requests-toolbelt
, requests-file
, requests-mock
, xmlsec
}:

buildPythonPackage rec {
  pname = "zeep";
  version = "4.1.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mvantellingen";
    repo = "python-zeep";
    rev = version;
    sha256 = "sha256-fJLr2LJpbNQTl183R56G7sJILfm04R39qpJxLogQLoo=";
  };

  propagatedBuildInputs = [
    attrs
    cached-property
    defusedxml
    httpx
    isodate
    lxml
    platformdirs
    pytz
    requests
    requests-file
    requests-toolbelt
    xmlsec
  ];

  checkInputs = [
    aiohttp
    aioresponses
    freezegun
    mock
    pretend
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
    requests-mock
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # lxml.etree.XMLSyntaxError: Extra content at the end of the document, line 2, column 64
    "test_mime_content_serialize_text_xml"
    # Tests are outdated
    "test_load"
    "test_load_cache"
    "test_post"
  ];

  pythonImportsCheck = [
    "zeep"
  ];

  meta = with lib; {
    description = "Python SOAP client";
    homepage = "http://docs.python-zeep.org";
    license = licenses.mit;
    maintainers = with maintainers; [ rvl ];
  };
}
