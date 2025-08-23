{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  pythonOlder,

  cython,
  geos,
  numpy,
  oldest-supported-numpy,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "shapely";
  version = "2.1.0";
  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "shapely";
    repo = "shapely";
    tag = version;
    hash = "sha256-Co3acjWsGWjwzMoklRx2CqBDOlEpaj3wWenLWxopvKY=";
  };

  patches = [
    # Fix tests for GEOS 3.14
    (fetchpatch {
      url = "https://github.com/shapely/shapely/commit/a561132c4e13c1fde597f56a8a7133c3c09b9928.patch";
      hash = "sha256-a9gDfw2Dw+fd82T9f0BufYd/+gxE+ALvWyLm4vHygzU=";
    })
    (fetchpatch {
      url = "https://github.com/shapely/shapely/commit/56e16e6eb27c54c6c24b9a251c12414e289fb7d0.patch";
      hash = "sha256-JyjPVcJswEozF4C73QotKsPou55H41Ct9oVgkxhDhbk=";
    })
    (fetchpatch {
      url = "https://github.com/shapely/shapely/commit/19f807961da0a14ac707e4540c91b8d60d52dd08.patch";
      hash = "sha256-3NHNiIOf9tbhFS/RAsRw1Yp/Bxy957WpsT+R5Vwp8uU=";
    })
  ];

  nativeBuildInputs = [
    cython
    geos # for geos-config
    oldest-supported-numpy
    setuptools
    wheel
  ];

  buildInputs = [ geos ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Fix a ModuleNotFoundError. Investigated at:
  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    cd $out
  '';

  disabledTests = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
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
    changelog = "https://github.com/shapely/shapely/blob/${version}/CHANGES.txt";
    description = "Manipulation and analysis of geometric objects";
    homepage = "https://github.com/shapely/shapely";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
}
