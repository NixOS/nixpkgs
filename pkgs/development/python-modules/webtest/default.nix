{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, nose
, webob
, six
, beautifulsoup4
, waitress
, mock
, pyquery
, wsgiproxy2
, PasteDeploy
}:

buildPythonPackage rec {
  version = "2.0.35";
  pname = "webtest";
  disabled = isPy27; # paste.deploy is not longer a valid import

  src = fetchPypi {
    pname = "WebTest";
    inherit version;
    sha256 = "sha256-qsFotbK08gCvTjWGfPMWcSIQ49XbgcHL3/OHImR7sIc=";
  };

  preConfigure = ''
    substituteInPlace setup.py --replace "nose<1.3.0" "nose"
  '';

  propagatedBuildInputs = [
    webob
    six
    beautifulsoup4
    waitress
  ];

  checkInputs = [
    nose
    mock
    PasteDeploy
    wsgiproxy2
    pyquery
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "webtest" ];

  meta = with lib; {
    description = "Helper to test WSGI applications";
    homepage = "https://webtest.readthedocs.org/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
