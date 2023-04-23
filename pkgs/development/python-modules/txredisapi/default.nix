{ lib, buildPythonPackage, fetchFromGitHub, nixosTests, six, twisted }:

buildPythonPackage rec {
  pname = "txredisapi";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "IlyaSkriblovsky";
    repo = "txredisapi";
    rev = "1.4.7";
    sha256 = "1f7j3c5l7jcfphvsk7nqmgyb4jaydbzq081m555kw0f9xxak0pgq";
  };

  propagatedBuildInputs = [ six twisted ];

  doCheck = false;
  pythonImportsCheck = [ "txredisapi" ];

  passthru.tests.unit-tests = nixosTests.txredisapi;

  meta = with lib; {
    homepage = "https://github.com/IlyaSkriblovsky/txredisapi";
    description = "non-blocking redis client for python";
    license = licenses.asl20;
    maintainers = with maintainers; [ dandellion ];
  };
}

