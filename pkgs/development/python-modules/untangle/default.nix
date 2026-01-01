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

<<<<<<< HEAD
  meta = {
    description = "Convert XML documents into Python objects";
    homepage = "https://github.com/stchris/untangle";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.arnoldfarkas ];
=======
  meta = with lib; {
    description = "Convert XML documents into Python objects";
    homepage = "https://github.com/stchris/untangle";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
