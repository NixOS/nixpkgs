{ stdenv
, buildPythonPackage
, python
, fetchPypi
, pbr
, testtools
}:

buildPythonPackage rec {
 pname = "testscenarios";
 version = "0.5.0";

 src = fetchPypi {
   inherit pname version;
   sha256 = "c257cb6b90ea7e6f8fef3158121d430543412c9a87df30b5dde6ec8b9b57a2b6";
 };

 propagatedBuildInputs = [ testtools pbr ];

 checkPhase = ''
   ${python.interpreter} -m testtools.run testscenarios.test_suite
 '';

 meta = with stdenv.lib; {
   description = "A pyunit extension for dependency injection";
   homepage = https://pypi.python.org/pypi/testscenarios;
   license = licenses.asl20;
   maintainers = [ maintainers.costrouc ];
 };
}
