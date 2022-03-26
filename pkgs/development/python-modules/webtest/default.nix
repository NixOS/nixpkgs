{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, webob
, six
, beautifulsoup4
, waitress
, pyquery
, wsgiproxy2
, pastedeploy
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "3.0.0";
  pname = "webtest";
  disabled = isPy27; # paste.deploy is not longer a valid import

  src = fetchPypi {
    pname = "WebTest";
    inherit version;
    sha256 = "54bd969725838d9861a9fa27f8d971f79d275d94ae255f5c501f53bb6d9929eb";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "nose<1.3.0" "nose"
  '';

  propagatedBuildInputs = [
    webob
    six
    beautifulsoup4
    waitress
  ];

  checkInputs = [
    pytestCheckHook
    pastedeploy
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
