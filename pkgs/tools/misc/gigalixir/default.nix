{ stdenv
, lib
, python3
, fetchPypi
, git
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gigalixir";
  version = "1.12.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T16+0F28/SxDl53GGTRzKbG+ghbL/80NkY08WpCixhA=";
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
    # These following test's are now depraced and removed, check out these commits:
    # https://github.com/gigalixir/gigalixir-cli/commit/00b758ed462ad8eff6ff0b16cd37fa71f75b2d7d
    # https://github.com/gigalixir/gigalixir-cli/commit/76fa25f96e71fd75cc22e5439b4a8f9e9ec4e3e5
    "test_create_config"
    "test_delete_free_database"
    "test_get_free_databases"
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
    mainProgram = "gigalixir";
  };
}
