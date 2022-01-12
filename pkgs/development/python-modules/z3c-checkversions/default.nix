{ lib
, buildPythonPackage
, fetchPypi
, python
, zc-buildout
, zope_testrunner
}:

buildPythonPackage rec {
  pname = "z3c-checkversions";
  version = "1.2";

  src = fetchPypi {
    inherit version;
    pname = "z3c.checkversions";
    sha256 = "94c7ab0810ee6fdb66a4689b48e537b57e2dbee277cb1de2ece7a7f4d8c83001";
  };

  propagatedBuildInputs = [ zc-buildout ];
  checkInputs = [ zope_testrunner ];
  doCheck = !python.pkgs.isPy27;
  checkPhase = ''
    ${python.interpreter} -m zope.testrunner --test-path=src []
  '';

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/z3c.checkversions";
    description = "Find newer package versions on PyPI";
    license = licenses.zpl21;
  };
}
