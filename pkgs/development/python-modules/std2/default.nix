{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "std2";
  version = "0.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "std2";
    rev = "808a4ae1e050033a3863c35175894aa2a97320b2";
    hash = "sha256-Setty21ZMUAedN80ZwiMisQNiQmQR7E9khgVsExEHNc=";
  };

  nativeBuildInputs = [ setuptools ];

  meta = with lib; {
    homepage = "https://github.com/ms-jpq/std2";
    description = "Dependency to chadtree and coq_nvim plugins";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ GaetanLepage _404wolf ];
  };
}
