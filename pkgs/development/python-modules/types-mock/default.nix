{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-mock";
  version = "5.1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3kjTdm5OMDTv2LJtqeCeSQjzHlMTel/i778fur7haZY=";
  };

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Type stub package for the mock package";
    homepage = "https://pypi.org/project/types-mock";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
