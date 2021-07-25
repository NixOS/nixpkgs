{ lib
, aiohttp
, aioresponses
, appdirs
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
  version = "4.0.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mvantellingen";
    repo = "python-zeep";
    rev = version;
    sha256 = "1rwmwk47fxs8dxwv5dr6gbnbiyilznifb47fhbxgzj231w0y82cm";
  };

  propagatedBuildInputs = [
    appdirs
    attrs
    cached-property
    defusedxml
    httpx
    isodate
    lxml
    pytz
    requests
    requests-toolbelt
    requests-file
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
    xmlsec
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # lxml.etree.XMLSyntaxError: Extra content at the end of the document, line 2, column 64
    "test_mime_content_serialize_text_xml"
  ];

  pythonImportsCheck = [ "zeep" ];

  meta = with lib; {
    description = "Python SOAP client";
    homepage = "http://docs.python-zeep.org";
    license = licenses.mit;
    maintainers = with maintainers; [ rvl ];
  };
}
