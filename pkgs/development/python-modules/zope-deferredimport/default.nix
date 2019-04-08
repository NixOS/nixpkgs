{ lib
, buildPythonPackage
, fetchPypi
, zope_proxy
, zope_testrunner
}:

buildPythonPackage rec {
  pname = "zope-deferredimport";
  version = "4.3";

  src = fetchPypi {
    pname = "zope.deferredimport";
    inherit version;
    sha256 = "2ddef5a7ecfff132a2dd796253366ecf9748a446e30f1a0b3a636aec9d9c05c5";
  };

  propagatedBuildInputs = [ zope_proxy ];

  checkInputs = [ zope_testrunner ];

  checkPhase = ''
    zope-testrunner --test-path=src []
  '';

  meta = with lib; {
    description = "Allows you to perform imports names that will only be resolved when used in the code";
    homepage = http://github.com/zopefoundation/zope.deferredimport;
    license = licenses.zpl21;
  };
}
