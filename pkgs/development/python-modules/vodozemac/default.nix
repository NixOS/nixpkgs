{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "vodozemac";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matrix-nio";
    repo = "vodozemac-python";
    rev = finalAttrs.version;
    hash = "sha256-y0mJsDRJzhwkYOERyMxvw4ih6bSMtmT+YTXds1bIyMI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-owvBFMoem6hn4dC9pR/DVqZoHFl7oIRBBodmAgWmDxU=";
  };

  nativeBuildInputs = [
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  meta = {
    description = "Python bindings for vodozemac";
    homepage = "https://github.com/matrix-nio/vodozemac-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
  };
})
