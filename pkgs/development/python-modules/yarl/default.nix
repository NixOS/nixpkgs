{ lib
, fetchPypi
, buildPythonPackage
, multidict
, pytestrunner
, pytest
, idna
}:

buildPythonPackage rec {
  pname = "yarl";
  version = "0.17.0";
  name = "${pname}-${version}";
  src = fetchPypi {
    inherit pname version;
    sha256 = "2e4e1aec650ad80e73e7063941cd8aadb48e72487ec680a093ad364cc61efe64";
  };

  checkInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ multidict idna ];

  meta = {
    description = "Yet another URL library";
    homepage = https://github.com/aio-libs/yarl/;
    license = lib.licenses.asl20;
  };
}