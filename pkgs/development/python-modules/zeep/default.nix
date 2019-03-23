{ fetchPypi
, lib
, buildPythonPackage
, appdirs
, cached-property
, defusedxml
, isodate
, lxml
, pytz
, requests_toolbelt
, six
# test dependencies
, aiohttp
, aioresponses
, freezegun
, mock
, nose
, pretend
, pytest_3
, pytestcov
, requests-mock
, tornado
, attrs
}:

buildPythonPackage rec {
  pname = "zeep";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bfpdy3hi8aa45piwg5gj0xxa187v13d66qr1ki73qn7c6rbizp5";
  };

  propagatedBuildInputs = [
    aiohttp
    attrs
    appdirs
    cached-property
    defusedxml
    isodate
    lxml
    pytz
    requests_toolbelt
    six
  ];

  checkInputs = [
    aioresponses
    tornado
    pytest_3
    freezegun
    mock
    nose
    pretend
    requests-mock
    pytestcov
  ];

  postPatch = ''
    # remove overly strict bounds and lint requirements
    sed -e "s/freezegun==.*'/freezegun'/" \
        -e "s/pytest-cov==.*'/pytest-cov'/" \
        -e "s/'isort.*//" \
        -e "s/'flake8.*//" \
        -i setup.py

    # locale.preferredencoding() != 'utf-8'
    sed -e "s/xsd', 'r')/xsd', 'r', encoding='utf-8')/" -i tests/*.py

    # cache defaults to home directory, which doesn't exist
    sed -e "s|SqliteCache()|SqliteCache(path='./zeeptest.db')|" \
        -i tests/test_transports.py

    # requires xmlsec python module
    rm tests/test_wsse_signature.py
  '';

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = http://docs.python-zeep.org;
    license = licenses.mit;
    description = "A modern/fast Python SOAP client based on lxml / requests";
    maintainers = with maintainers; [ rvl ];
  };
}
