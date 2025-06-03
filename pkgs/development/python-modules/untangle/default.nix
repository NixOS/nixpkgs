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
    # 1.1.1 is not tagged on GitHub
    tag = version;
    hash = "sha256-cJkN8vT5hW5hRuLxr/6udwMO4GVH1pJhAc6qmPO2EEI=";
  };

  propagatedBuildInputs = [ defusedxml ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  meta = with lib; {
    description = "Convert XML documents into Python objects";
    homepage = "https://github.com/stchris/untangle";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
