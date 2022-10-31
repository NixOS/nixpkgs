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
  version = "0.18.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-biGGn0YAUbSO1hCJ4kU0ZWlqlXl/HRrBS3iIA3myRI8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-nmkIKA4EDMOeppOxKwLSh3oREInlDIcFzE7/EYZRGKY=";
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

  checkInputs = [
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
