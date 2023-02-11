{ stdenv
, lib
, python3
, git
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gigalixir";
  version = "1.3.0";
  format = "setuptools";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-kNtybgv8j7t1tl6R5ZuC4vj5fnEcEenuNt0twA1kAh0=";
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
