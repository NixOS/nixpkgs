{ lib
, buildPythonPackage
, fetchPypi
, zope_proxy
, zope_testrunner
}:

buildPythonPackage rec {
  pname = "zope-deferredimport";
  version = "4.3.1";

  src = fetchPypi {
    pname = "zope.deferredimport";
    inherit version;
    sha256 = "57b2345e7b5eef47efcd4f634ff16c93e4265de3dcf325afc7315ade48d909e1";
  };

  propagatedBuildInputs = [ zope_proxy ];

  checkInputs = [ zope_testrunner ];

  checkPhase = ''
    zope-testrunner --test-path=src []
  '';

  doCheck = false;

  meta = with lib; {
    description = "Allows you to perform imports names that will only be resolved when used in the code";
    homepage = "https://github.com/zopefoundation/zope.deferredimport";
    license = licenses.zpl21;
  };
}
