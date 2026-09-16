{
  lib,
  buildPythonPackage,
  torchlensmaker,

  # build-system
  uv-build,

  # dependencies
  torch,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "torchimplicit";
  version = "0.1.0";
  pyproject = true;
  __structuredAttrs = true;

  inherit (torchlensmaker)
    src
    ;

  sourceRoot = "${finalAttrs.src.name}/torchimplicit";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.10.9,<0.11.0" "uv_build"
  '';

  build-system = [
    uv-build
  ];

  dependencies = [
    torch
  ];

  pythonImportsCheck = [
    "torchimplicit"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Implicit 2D and 3D surfaces in PyTorch";

    inherit (torchlensmaker.meta)
      homepage
      changelog
      license
      maintainers
      teams
      ;
  };
})
