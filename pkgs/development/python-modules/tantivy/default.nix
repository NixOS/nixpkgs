{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # nativeBuildInputs
  pkg-config,

  # tests
  mktestdocs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tantivy";
  version = "0.25.1";
  pyproject = true;

  # # Python sources are not on the main GitHub repo
  # src = fetchPypi {
  #   inherit pname version;
  #   hash = "sha256-aKMxRpmn0Y/PM4tSuujORql93hEoo+R+M/pNt/cfJl4=";
  # };
  src = fetchFromGitHub {
    owner = "quickwit-oss";
    repo = "tantivy-py";
    tag = version;
    hash = "sha256-rayr38TfBYCKDddJabhC+r/jIyqJtpKct81h1z8YPFw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-xJdAD/E17mzTkRq5wwNxYtNtv386U1xD4mJhY0LiZFE=";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [
    pkgs.zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  pythonImportsCheck = [ "tantivy" ];

  preCheck = ''
    rm -rf tantivy
  '';

  nativeCheckInputs = [
    mktestdocs
    pytestCheckHook
  ];

  meta = {
    description = "Official Python bindings for the Tantivy search engine";
    homepage = "https://pypi.org/project/tantivy/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
