{ stdenv
, lib
, python3
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, git
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gigalixir";
<<<<<<< HEAD
  version = "1.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-01CoCT++mGiwZ40vAjU3OFE74WGWlBuhaTwsNFIR1a0=";
=======
  version = "1.3.0";
  format = "setuptools";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-kNtybgv8j7t1tl6R5ZuC4vj5fnEcEenuNt0twA1kAh0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," "" \
      --replace "cryptography==" "cryptography>="
  '';

  propagatedBuildInputs = with python3.pkgs; [
    click
    pygments
    pyopenssl
    qrcode
    requests
    rollbar
    stripe
  ];

  nativeCheckInputs = [
    git
  ] ++ (with python3.pkgs; [
    httpretty
    pytestCheckHook
    sure
  ]);

  disabledTests = [
    # Test requires network access
    "test_rollback_without_version"
<<<<<<< HEAD
    # These following test's are now depraced and removed, check out these commits:
    # https://github.com/gigalixir/gigalixir-cli/commit/00b758ed462ad8eff6ff0b16cd37fa71f75b2d7d
    # https://github.com/gigalixir/gigalixir-cli/commit/76fa25f96e71fd75cc22e5439b4a8f9e9ec4e3e5
    "test_create_config"
    "test_delete_free_database"
    "test_get_free_databases"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "gigalixir"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Gigalixir Command-Line Interface";
    homepage = "https://github.com/gigalixir/gigalixir-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
