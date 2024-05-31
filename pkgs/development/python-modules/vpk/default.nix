{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "vpk";
  version = "1.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = "vpk";
    rev = "v${version}";
    hash = "sha256-SPkPb8kveAR2cN9kd2plS+TjmBYBCfa6pJ0c22l69M0=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Library for working with Valve Pak files";
    mainProgram = "vpk";
    homepage = "https://github.com/ValvePython/vpk";
    license = licenses.mit;
    maintainers = with maintainers; [ joshuafern ];
  };
}
