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
  setuptools = true;

  src = fetchFromGitHub {
    owner = "ICAMS";
    repo = "grace-tensorpotential";
    rev = "0.5.1";
    hash = "sha256-nVIHW2aiV79Ul07lqt/juGc8oPYJUeb7TLtqMyOQjGs=";
  };

  meta = with lib; {
    description = "GRACE models and gracemaker (as implemented in TensorPotential package)";
    homepage = "https://github.com/ICAMS/grace-tensorpotential";
    changelog = "https://github.com/ICAMS/grace-tensorpotential/releases/tag/${version}";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ sh4k0 ];
  };
}
