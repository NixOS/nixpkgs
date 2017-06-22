{ fetchPypi
, lib
, buildPythonPackage
, python
, isPy3k
, appdirs
, cached-property
, defusedxml
, isodate
, lxml
, pytz
, requests_toolbelt
, six
# test dependencies
, freezegun
, mock
, nose
, pretend
, pytest
, pytestcov
, requests-mock
, testtools
}:

let
  pname = "zeep";
  version = "2.0.0";
in buildPythonPackage {
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b9bd6b8772d6b505118c11d6924eb7df0decf12bbbeb43b1c27d781817361ad";
  };

  propagatedBuildInputs = [
    appdirs
    cached-property
    defusedxml
    isodate
    lxml
    pytz
    requests_toolbelt
    six
  ];

  # testtools dependency not supported for py3k
  doCheck = !isPy3k;

  buildInputs = if isPy3k then [] else [
    freezegun
    mock
    nose
    pretend
    pytest
    pytestcov
    requests-mock
  ];

  patchPhase = ''
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
    runHook preCheck
    ${python.interpreter} -m pytest tests
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "http://docs.python-zeep.org";
    license = licenses.mit;
    description = "A modern/fast Python SOAP client based on lxml / requests";
    maintainers = with maintainers; [ rvl ];
  };
}
