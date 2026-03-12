{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  defusedxml,
}:

buildPythonPackage rec {
  pname = "untangle";
  version = "1.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "stchris";
    repo = "untangle";
    tag = version;
    hash = "sha256-i7B37Rj46ZVlN8vaMq7FoqS9dOoC680AqASdGk6pBJU=";
  };

  propagatedBuildInputs = [ defusedxml ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  meta = {
    description = "Convert XML documents into Python objects";
    homepage = "https://github.com/stchris/untangle";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.arnoldfarkas ];
  };
}
