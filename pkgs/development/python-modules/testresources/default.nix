{ lib, buildPythonPackage, fetchPypi, python
, pbr, fixtures, testtools }:

buildPythonPackage rec {
  pname = "testresources";
  version = "2.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee9d1982154a1e212d4e4bac6b610800bfb558e4fb853572a827bc14a96e4417";
  };

  propagatedBuildInputs = [ pbr ];

  nativeCheckInputs = [ fixtures testtools ];

  checkPhase = ''
    ${python.interpreter} -m testtools.run discover
  '';

  meta = with lib; {
    description = "Pyunit extension for managing expensive test resources";
    homepage = "https://launchpad.net/testresources";
    license = licenses.bsd2;
  };
}
