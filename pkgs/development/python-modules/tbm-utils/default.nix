{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, attrs
, pendulum
, poetry-core
, pprintpp
, pytestCheckHook
, pythonRelaxDepsHook
, wrapt
}:

buildPythonPackage rec {
  pname = "tbm-utils";
  version = "2.6.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "thebigmunch";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-AEKawsAxDSDNkIaXEFFgdEBOY2PpASDrhlDrsnM5eyA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'poetry>=1.0.0' 'poetry-core' \
      --replace 'poetry.masonry.api' 'poetry.core.masonry.api'
  '';

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    attrs
    pendulum
    pprintpp
    wrapt
  ];

  pythonRelaxDeps = [
    "attrs"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

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

  pythonImportsCheck = [
    "tbm_utils"
  ];

  meta = {
    description = "A commonly-used set of utilities";
    homepage = "https://github.com/thebigmunch/tbm-utils";
    changelog = "https://github.com/thebigmunch/tbm-utils/blob/${version}/CHANGELOG.md";
    license = [ lib.licenses.mit ];
  };
}
