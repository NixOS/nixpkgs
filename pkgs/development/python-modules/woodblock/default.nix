{ lib
, buildPythonPackage
, fetchPypi
, click
, multimethod
, numpy
}:
buildPythonPackage rec {
  pname = "woodblock";
  version = "0.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0347ece920b7009d94551983a01f42db02920ca8d7b0ff36d24a337e2c937f7";
  };

  propagatedBuildInputs = [
    click
    multimethod
    numpy
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "woodblock"
  ];

  meta = with lib; {
    description = "A framework to generate file carving test data";
    homepage = "https://github.com/fkie-cad/woodblock";
    license = licenses.mit;
    maintainers = teams.determinatesystems.members;
  };
}
