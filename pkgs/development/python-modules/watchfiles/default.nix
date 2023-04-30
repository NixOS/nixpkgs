{ lib
, stdenv
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
, CoreServices
, libiconv
}:

buildPythonPackage rec {
  pname = "watchfiles";
  version = "0.19.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-NmmeoaIfFMNKCcjH6tPnkpflkN35bKlT76MqF9W8LBc=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-9ruk3PMcWNLOIGth5fo91/miyF17lgERWL3F4y4as18=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    libiconv
  ];

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

  nativeCheckInputs = [
    dirty-equals
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ];

  postPatch = ''
    sed -i "/^requires-python =.*/a version = '${version}'" pyproject.toml
  '';

  preCheck = ''
    rm -rf watchfiles
  '';

  pythonImportsCheck = [
    "watchfiles"
  ];

  meta = with lib; {
    description = "File watching and code reload";
    homepage = "https://watchfiles.helpmanual.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
