{
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
  lib,
  pytest,
}:

buildPythonPackage rec {
  pname = "viewstate";
  version = "0.6.0";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "yuvadm";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-cXT5niE3rNdqmNqnITWy9c9/MF0gZ6LU2i1uzfOzkUI=";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = {
    description = ".NET viewstate decoder";
    homepage = "https://github.com/yuvadm/viewstate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
