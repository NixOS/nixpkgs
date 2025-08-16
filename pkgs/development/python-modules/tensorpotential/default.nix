{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tensorpotential";
  version = "0.5.1";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "ICAMS";
    repo = "grace-tensorpotential";
    tag = "0.5.1";
    hash = "sha256-nVIHW2aiV79Ul07lqt/juGc8oPYJUeb7TLtqMyOQjGs=";
  };
  dependencies = with pkgs.python312Packages; [
    tf-keras
    scipy
    numpy #<2.0.0
    sumpy
    #matscipy
    pandas #<3.0.0
    ase
    pyyaml #>=6.0.2
    tqdm
  ];

  meta = {
    description = "GRACE models and gracemaker (as implemented in TensorPotential package)";
    homepage = "https://github.com/ICAMS/grace-tensorpotential";
    changelog = "https://github.com/ICAMS/grace-tensorpotential/releases/tag/${version}";
    license = with lib.licenses; [ asl ];
    maintainers = with lib.maintainers; [ sh4k0 ];
  };
}
