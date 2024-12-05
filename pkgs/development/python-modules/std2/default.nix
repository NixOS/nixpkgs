{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "std2";
  version = "0-unstable-2024-09-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "std2";
    rev = "205d1f52e9b5438ef2b732c77e1144847cafa8d0";
    hash = "sha256-WdUefadEk92cGnDI+KbQBpjg+d7KgI6bjlQlyhRRRFA=";
  };

  nativeBuildInputs = [ setuptools ];

  meta = {
    homepage = "https://github.com/ms-jpq/std2";
    description = "Dependency to chadtree and coq_nvim plugins";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
