{
  lib,
  stdenv,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pendulum,
  poetry-core,
  pprintpp,
  pytestCheckHook,
  pythonOlder,
  wrapt,
}:

buildPythonPackage rec {
  pname = "tbm-utils";
  version = "2.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "thebigmunch";
    repo = "tbm-utils";
    rev = "refs/tags/${version}";
    hash = "sha256-AEKawsAxDSDNkIaXEFFgdEBOY2PpASDrhlDrsnM5eyA=";
  };

  patches = [
    # Migrate to pendulum > 3, https://github.com/thebigmunch/tbm-utils/pull/3
    (fetchpatch {
      name = "support-pendulum-3.patch";
      url = "https://github.com/thebigmunch/tbm-utils/commit/473534fae2d9a8dea9100cead6c54cab3f5cd0cd.patch";
      hash = "sha256-3T0KhSmO9r1vM67FWEnTZMQV4b5jS2xtPHI0t9NnCmI=";
    })
    (fetchpatch {
      name = "update-testsupport-pendulum-3.patch";
      url = "https://github.com/thebigmunch/tbm-utils/commit/a0331d0c15f11cd26bfbb42eebd17296167161ed.patch";
      hash = "sha256-KG6yfnnBltavbNvIBTdbK+CPXwZTLYl14925RY2a8vs=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'poetry>=1.0.0' 'poetry-core' \
      --replace-fail 'poetry.masonry.api' 'poetry.core.masonry.api'
  '';

  pythonRelaxDeps = [ "attrs" ];

  build-system = [ poetry-core ];


  propagatedBuildInputs = [
    attrs
    pendulum
    pprintpp
    wrapt
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # Skip on macOS because /etc/localtime is accessed through the pendulum
    # library, which is not allowed in a sandboxed build.
    "test_create_parser_filter_dates"
    "test_parse_args"
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    # Skip on macOS because /etc/localtime is accessed through the pendulum
    # library, which is not allowed in a sandboxed build.
    "tests/test_datetime.py"
    "tests/test_misc.py"
  ];

  pythonImportsCheck = [ "tbm_utils" ];

  meta = with lib; {
    description = "Commonly-used set of utilities";
    homepage = "https://github.com/thebigmunch/tbm-utils";
    changelog = "https://github.com/thebigmunch/tbm-utils/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
