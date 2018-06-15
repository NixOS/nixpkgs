{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "semantic_version";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h2l9xyg1zzsda6kjcmfcgycbvrafwci283vcr1v5sbk01l2hhra";
  };

  # ModuleNotFoundError: No module named 'tests'
  doCheck = false;

  meta = with lib; {
    description = "A library implementing the 'SemVer' scheme";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus makefu ];
  };
}
