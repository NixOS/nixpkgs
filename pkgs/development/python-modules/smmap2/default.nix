{ lib, fetchPypi, buildPythonPackage, nosexcover }:

buildPythonPackage rec {
  pname = "smmap2";
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hvn28p3zvxa98sbi9lrqvv2ps4q284j4jq9a619zw0m7yv0sly7";
  };

  checkInputs = [ nosexcover ];

  meta = {
    description = "A pure python implementation of a sliding window memory map manager";
    homepage = https://pypi.org/project/smmap2;
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
