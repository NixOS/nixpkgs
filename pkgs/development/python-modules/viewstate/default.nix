{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "viewstate";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yuvadm";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-cXT5niE3rNdqmNqnITWy9c9/MF0gZ6LU2i1uzfOzkUI=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = ".NET viewstate decoder";
    homepage = "https://github.com/yuvadm/viewstate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
