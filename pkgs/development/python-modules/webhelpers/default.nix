{
  lib,
  buildPythonPackage,
  fetchPypi,
  routes,
  markupsafe,
  webob,
  nose,
}:

buildPythonPackage rec {
  pname = "webhelpers";
  version = "1.3";

  src = fetchPypi {
    pname = "WebHelpers";
    inherit version;
    hash = "sha256-6obyhOkpNmt3QkupqJNB9Dro3uPL64cC9zvPhgWKpYM=";
  };

  buildInputs = [
    routes
    markupsafe
    webob
    nose
  ];

  # TODO: failing tests https://bitbucket.org/bbangert/webhelpers/pull-request/1/fix-error-on-webob-123/diff
  doCheck = false;

  meta = with lib; {
    homepage = "https://webhelpers.readthedocs.org/en/latest/";
    description = "Web Helpers";
    license = licenses.free;
    maintainers = with maintainers; [ domenkozar ];
  };
}
