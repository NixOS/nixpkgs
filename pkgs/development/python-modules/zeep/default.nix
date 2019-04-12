{ fetchPypi
, lib
, buildPythonPackage
, isPy3k
, appdirs
, attrs
, cached-property
, defusedxml
, isodate
, lxml
, requests
, requests_toolbelt
, six
, pytz
, tornado
, aiohttp
# test dependencies
, freezegun
, mock
, pretend
, pytest_3
, pytestcov
, requests-mock
, aioresponses
}:

buildPythonPackage rec {
  pname = "zeep";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "144dk7gw93l4amrwmp5vzxxkcjsgkx6fjqzvsawx2iap23j605j9";
  };

  propagatedBuildInputs = [
    appdirs
    attrs
    cached-property
    defusedxml
    isodate
    lxml
    requests
    requests_toolbelt
    six
    pytz

    # optional requirements
    tornado
  ] ++ lib.optional isPy3k aiohttp;

  checkInputs = [
    freezegun
    mock
    pretend
    pytestcov
    pytest_3
    requests-mock
  ] ++ lib.optional isPy3k aioresponses;

  checkPhase = ''
    runHook preCheck
    # ignored tests requires xmlsec python module
    HOME=$(mktemp -d) pytest tests --ignore tests/test_wsse_signature.py
    runHook postCheck
  '';

  meta = with lib; {
    homepage = http://docs.python-zeep.org;
    license = licenses.mit;
    description = "A modern/fast Python SOAP client based on lxml / requests";
    maintainers = with maintainers; [ rvl ];
  };
}
