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
}:

buildPythonPackage rec {
  pname = "watchfiles";
  version = "0.18.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-XEhu6M1hFi3/gAKZcei7KJSrIhhlZhlvZvbfyA6VLR4=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-IWONA3o+2emJ7cKEw5xYSMdWzGuUSwn1B70zUDzj7Cw=";
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
    broken = stdenv.isDarwin;
  };
}
