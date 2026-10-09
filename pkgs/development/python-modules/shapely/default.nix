{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pyprojectVersionPatchHook,

  # build deps
  cython,
  meson-python,
  pkg-config,

  # runtime deps
  geos,
  numpy,
  oldest-supported-numpy,
}:

buildPythonPackage rec {
  pname = "shapely";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shapely";
    repo = "shapely";
    tag = version;
    hash = "sha256-ddBbNAahYK1/+VtCYVqjrhOfRAtZERv7axTHrYlYBfA=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
    pkg-config
  ];

  build-system = [
    meson-python
    cython
  ];

  buildInputs = [
    oldest-supported-numpy
    geos
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Fix a ModuleNotFoundError. Investigated at:
  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    cd $out
  '';

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # FIXME(lf-): these logging tests are broken, which is definitely our
    # fault. I've tried figuring out the cause and failed.
    #
    # It is apparently some sandbox or no-sandbox related thing on macOS only
    # though.
    "test_error_handler_exception"
    "test_error_handler"
    "test_info_handler"
  ];

  pythonImportsCheck = [ "shapely" ];

  meta = {
    changelog = "https://github.com/shapely/shapely/blob/${src.tag}/CHANGES.txt";
    description = "Manipulation and analysis of geometric objects";
    homepage = "https://github.com/shapely/shapely";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
}
