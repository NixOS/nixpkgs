{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,

  # reverse dependencies
  mashumaro,
  pydantic,
}:

buildPythonPackage rec {
  pname = "typing-extensions";
  version = "4.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python";
    repo = "typing_extensions";
    tag = version;
    hash = "sha256-3oAlwvNSJ7NhPiHekh4SJI99cPFh29KCCR9314QzsvQ=";
  };

  build-system = [ flit-core ];

  pythonImportsCheck = [ "typing_extensions" ];

  passthru.tests = {
    inherit mashumaro pydantic;
  };

  meta = with lib; {
    description = "Backported and Experimental Type Hints for Python";
    changelog = "https://github.com/python/typing_extensions/blob/${version}/CHANGELOG.md";
    homepage = "https://github.com/python/typing";
    license = licenses.psfl;
    maintainers = with maintainers; [ pmiddend ];
  };
}
