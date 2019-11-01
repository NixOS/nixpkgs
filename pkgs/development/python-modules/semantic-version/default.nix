{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "semantic_version";
  version = "2.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "71c716e99086c44d068262b86e4775aa6db7fabee0743e4e33b00fbf6f672585";
  };

  # ModuleNotFoundError: No module named 'tests'
  doCheck = false;

  meta = with lib; {
    description = "A library implementing the 'SemVer' scheme";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus makefu ];
  };
}
