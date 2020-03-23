{ stdenv
, buildPythonPackage
, fetchPypi
, python
, zc_buildout
, zope_testrunner
}:

buildPythonPackage rec {
  pname = "z3c-checkversions";
  version = "1.1";

  src = fetchPypi {
    inherit version;
    pname = "z3c.checkversions";
    sha256 = "b45bd22ae01ed60933694fb5abede1ff71fe8ffa79b37082b2fcf38a2f0dec9d";
  };

  propagatedBuildInputs = [ zc_buildout ];
  checkInputs = [ zope_testrunner ];
  doCheck = !python.pkgs.isPy27;
  checkPhase = ''
    ${python.interpreter} -m zope.testrunner --test-path=src []
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/zopefoundation/z3c.checkversions;
    description = "Find newer package versions on PyPI";
    license = licenses.zpl21;
  };
}
