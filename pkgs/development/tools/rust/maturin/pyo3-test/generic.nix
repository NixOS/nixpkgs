# Derivation prototype, used by maturin and setuptools-rust
# passthrough tests.

{ lib
, fetchFromGitHub
, python
, rustPlatform

, nativeBuildInputs

, buildAndTestSubdir ? null
, format ? "pyproject"
, preConfigure ? ""
}:

python.pkgs.buildPythonPackage rec {
  pname = "word-count";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "pyo3";
    rev = "v${version}";
    hash = "sha256-NOMrrfo8WjlPhtGxWUOPJS/UDDdbLQRCXR++Zd6JmIA=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}";
    hash = "sha256-//TmozgWy9zrSpMKX92XdHj4fw/T1Elfgn4YhhR7ot0=";
  };

  patches = [ ./Cargo.lock.patch ];

  inherit buildAndTestSubdir format nativeBuildInputs preConfigure;

  pythonImportsCheck = [ "word_count" ];

  meta = with lib; {
    description = "PyO3 word count example";
    homepage = "https://github.com/PyO3/pyo3";
    license = licenses.asl20;
    maintainers = [ maintainers.danieldk ];
  };
}
