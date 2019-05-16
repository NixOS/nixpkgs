{ stdenv
, buildPythonPackage
, fetchPypi
, routes
, markupsafe
, webob
, nose
}:

buildPythonPackage rec {
  pname = "WebHelpers";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea86f284e929366b77424ba9a89341f43ae8dee3cbeb8702f73bcf86058aa583";
  };

  buildInputs = [ routes markupsafe webob nose ];

  # TODO: failing tests https://bitbucket.org/bbangert/webhelpers/pull-request/1/fix-error-on-webob-123/diff
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://webhelpers.readthedocs.org/en/latest/;
    description = "Web Helpers";
    license = licenses.free;
    maintainers = with maintainers; [ garbas domenkozar ];
  };

}
