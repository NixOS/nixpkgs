{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "semantic_version";
  version = "2.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lnnpxmf3z1rcfr5n562vbraq236s13wlj8fmw2kwr2mrq7lqb8r";
  };

  # ModuleNotFoundError: No module named 'tests'
  doCheck = false;

  meta = with lib; {
    description = "A library implementing the 'SemVer' scheme";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus makefu ];
  };
}
