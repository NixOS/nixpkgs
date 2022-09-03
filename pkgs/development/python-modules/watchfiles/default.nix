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
  version = "0.15.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DibxoVH7uOy9rxzhiN4HmihA7HtdzErmJOnsI/NWY5I=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-EakC/rSIS42Q4Y0pvWKG7mzppU5KjCktnC09iFMZM0A=";
  };

  nativeBuildInputs = [
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    rust.cargo
    rust.rustc
  ]);

  propagatedBuildInputs = [
    anyio
  ];

  preCheck = ''
    rm -rf watchfiles
  '';

  checkInputs = [
    dirty-equals
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "watchfiles"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Simple, modern file watching and code reload";
    homepage = "https://watchfiles.helpmanual.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
