{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "vpk";
  version = "1.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = "vpk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SPkPb8kveAR2cN9kd2plS+TjmBYBCfa6pJ0c22l69M0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "vpk" ];

  meta = {
    description = "Library for working with Valve Pak files";
    mainProgram = "vpk";
    homepage = "https://github.com/ValvePython/vpk";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
