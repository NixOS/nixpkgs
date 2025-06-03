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
  version = "4.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python";
    repo = "typing_extensions";
    tag = version;
    hash = "sha256-6wG+f0+sGI3sWy4EYeWDTffLicMiIkACHwrw0oP4Z1w=";
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
