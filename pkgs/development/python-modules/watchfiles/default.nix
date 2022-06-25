{ stdenv
, lib
, anyio
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
, setuptools-rust
, pythonOlder
, dirty-equals
, pytest-mock
, pytest-timeout
, pytestCheckHook
, python
}:

buildPythonPackage rec {
  pname = "watchfiles";
  version = "0.14.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XjmmyL7ZRqkYwGGk6/KkxL7e/JA43tQN4W3knTtc7t0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-sZMj1HQ37gAG3WM+qBMhcCQ2MuUGom23lF8c4L0RQzM=";
  };

  nativeBuildInputs = [
    setuptools-rust
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  propagatedBuildInputs = [
    anyio
  ];

  checkInputs = [
    dirty-equals
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "watchfiles"
  ];

  preCheck = ''
    cd tests
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Simple, modern file watching and code reload";
    homepage = "https://watchfiles.helpmanual.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
