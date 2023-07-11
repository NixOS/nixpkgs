{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
}:

buildPythonPackage {
  pname = "std2";
  version = "unstable-2023-07-05";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "std2";
    rev = "1080b7b657f75352481808a906939d16b6d956a1";
    hash = "sha256-shAuCZvyFGrW26uTnNeyvlAIABb1d9oeKpk9hQbtuEQ=";
  };

  nativeBuildInputs = [ setuptools ];

  meta = with lib; {
    homepage = "https://github.com/ms-jpq/std2";
    description = "Dependency to chadtree and coq_nvim plugins";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
