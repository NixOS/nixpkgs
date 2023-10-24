{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, six
, twisted
, nixosTests
}:

buildPythonPackage rec {
  pname = "txredisapi";
  version = "1.4.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "IlyaSkriblovsky";
    repo = "txredisapi";
    rev = "refs/tags/${version}";
    hash = "sha256-6Z2vurTAw9YHxvEiixtdxBH0YHj+Y9aTdsSkafPMZus=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    six
    twisted
  ]
  ++ twisted.optional-dependencies.tls;

  pythonImportsCheck = [
    "txredisapi"
  ];

  doCheck = false;

  passthru.tests.unit-tests = nixosTests.txredisapi;

  meta = with lib; {
    homepage = "https://github.com/IlyaSkriblovsky/txredisapi";
    description = "non-blocking redis client for python";
    license = licenses.asl20;
    maintainers = with maintainers; [ dandellion ];
  };
}

