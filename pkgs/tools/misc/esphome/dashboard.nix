{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchNpmDeps,

  # build-system
  setuptools,
  nodejs,
  npmHooks,

}:

buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20241120.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "dashboard";
    rev = "refs/tags/${version}";
    hash = "sha256-insoDWHqMFAGgmsY2ZgNuo1cl0WGJXRy398bt3ADORs=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-UKrF7yzyj09WBrmrJ6uzcRjIYrKwCqLQ5paiqnt/Xuc=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  postPatch = ''
    # https://github.com/esphome/dashboard/pull/639
    patchShebangs script/build
  '';

  preBuild = ''
    script/build
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "esphome_dashboard"
  ];

  meta = with lib; {
    description = "ESPHome dashboard";
    homepage = "https://esphome.io/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ hexa ];
  };
}
