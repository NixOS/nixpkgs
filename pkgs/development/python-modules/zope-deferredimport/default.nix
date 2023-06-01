{ lib
, buildPythonPackage
, fetchPypi
, zope_proxy
, zope_testrunner
}:

buildPythonPackage rec {
  pname = "zope-deferredimport";
  version = "4.4";

  src = fetchPypi {
    pname = "zope.deferredimport";
    inherit version;
    sha256 = "2ae3257256802787e52ad840032f39c1496d3ce0b7e11117f663420e4a4c9add";
  };

  propagatedBuildInputs = [ zope_proxy ];

  nativeCheckInputs = [ zope_testrunner ];

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
