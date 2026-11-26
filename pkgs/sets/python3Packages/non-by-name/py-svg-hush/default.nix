{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # build-system
  cargo,
  rustc,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "py-svg-hush";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jams2";
    repo = "py-svg-hush";
    tag = "v${version}";
    hash = "sha256-UlPB746UyIexiOp/YSrf4yIF1BvegXv0Hk84k1m34LU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-+uanZUeCdchcD/GU9Y61//TdzPQizWrEqyzNMoA8Gis=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "py_svg_hush" ];

  meta = {
    description = "Python bindings for svg-hush, a tool to sanitize SVG files";
    homepage = "https://github.com/jams2/py-svg-hush";
    changelog = "https://github.com/jams2/py-svg-hush/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
