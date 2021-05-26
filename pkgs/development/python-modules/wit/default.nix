{ lib, buildPythonPackage, fetchPypi
, requests, prompt_toolkit
}:

buildPythonPackage rec {
  pname = "wit";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y1m33anfsfd1aq4w2zz8s7c8ifhhxnvyxl75apaq37f8z0qlfqm";
  };

  propagatedBuildInputs =  [ requests prompt_toolkit ];
}
