{ lib, pkgs, buildPythonPackage, fetchPypi, isPy3k
, numpy
, scipy
, tables
, pandas
, nose
}:

buildPythonPackage rec {
  pname = "flammkuchen";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e9aab9b229ace70d879b85618a9ce0e88dd6ce35d4dbcdfd60c6b61c33a1b4fb";
  };

  checkInputs = [
    nose
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    tables
    pandas
  ];

  meta = {
    homepage = "https://github.com/portugueslab/flammkuchen";
    description = "Flexible HDF5 saving/loading library forked from deepdish (University of Chicago) and maintained by the Portugues lab";
    license = lib.licenses.bsd3;
    maintainer = with lib.maintainers; [ tbenst ];
  };
}
