{ lib, buildPythonPackage, fetchFromPyPI }:

buildPythonPackage rec {
  pname = "should-dsl";
  version = "2.1.2";

  src = fetchFromPyPI {
    inherit version;
    pname = "should_dsl";
    sha256 = "0ai30dxgygwzaj9sgdzyfr9p5b7gwc9piq59nzr4xy5x1zcm7xrn";
  };

  # There are no tests
  doCheck = false;

  meta = with lib; {
    description = "Should assertions in Python as clear and readable as possible";
    homepage = "http://www.should-dsl.info/";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
