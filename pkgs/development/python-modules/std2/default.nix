{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "std2";
  version = "unstable-2023-10-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "std2";
    rev = "6332e559ee51c3a7c956804afdd7e1cc6ad47965";
    hash = "sha256-huN7P/Ws6anrFXDG7L5xxMenS25BHquV9cMi1s7WFJ4=";
  };

  nativeBuildInputs = [ setuptools ];

  meta = with lib; {
    homepage = "https://github.com/ms-jpq/std2";
    description = "Dependency to chadtree and coq_nvim plugins";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
