{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "semantic_version";
  version = "2.8.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2cb2de0558762934679b9a104e82eca7af448c9f4974d1f3eeccff651df8a54";
  };

  # ModuleNotFoundError: No module named 'tests'
  doCheck = false;

  meta = with lib; {
    description = "A library implementing the 'SemVer' scheme";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus makefu ];
  };
}
