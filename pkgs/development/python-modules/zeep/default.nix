{ fetchPypi
, lib
, fetchpatch
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
, pytest
, pytestcov
, requests-mock
, aioresponses
}:

buildPythonPackage rec {
  pname = "zeep";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e98669cfeb60756231ae185498f9ae21b30b2681786b8de58ed34c3b93e41dd";
  };

  patches = [
    ( fetchpatch {
        url = "https://github.com/mvantellingen/python-zeep/pull/1006/commits/ba7edd6bf2b31023b31e8f17c161e1d6d5af3d29.patch";
        sha256 = "1j0jd5hmh457im9sbawaqf6pnfy36fhr9wqdim8wk5da9ixr0ajs";
     })
  ];

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
    pytest
    requests-mock
  ] ++ lib.optional isPy3k aioresponses;

  checkPhase = ''
    runHook preCheck
    # fix compatibility with pytest 4
    substituteInPlace tests/conftest.py \
       --replace 'request.node.get_marker("requests")' 'request.node.get_closest_marker("requests")'
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
