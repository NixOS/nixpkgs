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
  version = "20240620.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "dashboard";
    rev = "refs/tags/${version}";
    hash = "sha256-LmIxfX3rcRK90h31J0B5T02f48MCctFERgXxf0zkDm0=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-xMVESS1bPNJF07joUgY8ku+GWtflWhM8mYAv0emggc8=";
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
