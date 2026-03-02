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
  version = "1.4.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "IlyaSkriblovsky";
    repo = "txredisapi";
    tag = version;
    hash = "sha256-gPXkpUcHAuXx/olB/nKstRrfIUFFLf4gFyv7ReRvV2E=";
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
