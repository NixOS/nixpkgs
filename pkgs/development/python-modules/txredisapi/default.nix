{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  twisted,
  nixosTests,
}:

buildPythonPackage rec {
  pname = "txredisapi";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "IlyaSkriblovsky";
    repo = "txredisapi";
    tag = version;
    hash = "sha256-PXWw2AGeEbaxh9PG7MqTnhU5/5S90GQuq5PNwGIoKxY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    six
    twisted
  ]
  ++ twisted.optional-dependencies.tls;

  pythonImportsCheck = [ "txredisapi" ];

  doCheck = false;

  passthru.tests.unit-tests = nixosTests.txredisapi;

  meta = {
    homepage = "https://github.com/IlyaSkriblovsky/txredisapi";
    description = "Non-blocking redis client for python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
