{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "semantic_version";
  version = "2.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9dcc6fbad58da3c4d5eee2287025e226bb05c39463f14b741357801baae9dcce";
  };

  # ModuleNotFoundError: No module named 'tests'
  doCheck = false;

  meta = with lib; {
    description = "A library implementing the 'SemVer' scheme";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus makefu ];
  };
}
