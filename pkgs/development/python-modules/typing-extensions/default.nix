{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pythonOlder,

  # reverse dependencies
  mashumaro,
  pydantic,
}:

buildPythonPackage rec {
  pname = "typing-extensions";
  version = "4.13.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python";
    repo = "typing_extensions";
    rev = version;
    hash = "sha256-L9sHwr2rCkw1jrfA1M0kifXl2jUlTZKdmwQx275/Ndk=";
  };

  nativeBuildInputs = [ flit-core ];

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
