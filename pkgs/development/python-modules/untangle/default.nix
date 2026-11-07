{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  defusedxml,
}:

buildPythonPackage (finalAttrs: {
  pname = "untangle";
  version = "1.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "stchris";
    repo = "untangle";
    tag = finalAttrs.version;
    hash = "sha256-cJkN8vT5hW5hRuLxr/6udwMO4GVH1pJhAc6qmPO2EEI=";
  };

  propagatedBuildInputs = [ defusedxml ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlags = [
    "--start-directory=tests"
  ];

  meta = {
    description = "Convert XML documents into Python objects";
    homepage = "https://github.com/stchris/untangle";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
