<<<<<<< HEAD
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
=======
{ lib
, buildPythonPackage
, fetchPypi
, attrs
, pendulum
, pprintpp
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, wrapt
}:

buildPythonPackage rec {
  pname = "tbm-utils";
  version = "2.6.0";
<<<<<<< HEAD
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
=======

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v7pb3yirkhzbv1z5i1qp74vl880f56zvzfj68p08b5jxv64hmr3";
  };

  propagatedBuildInputs = [ attrs pendulum pprintpp wrapt ];

  # this versioning was done to prevent normal pip users from encountering
  # issues with package failing to build from source, but nixpkgs is better
  postPatch = ''
    substituteInPlace setup.py \
      --replace "'attrs>=18.2,<19.4'" "'attrs'"
  '';

  # No tests in archive.
  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "A commonly-used set of utilities";
    homepage = "https://github.com/thebigmunch/tbm-utils";
<<<<<<< HEAD
    changelog = "https://github.com/thebigmunch/tbm-utils/blob/${version}/CHANGELOG.md";
    license = [ lib.licenses.mit ];
  };
=======
    license = with lib.licenses; [ mit ];
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
