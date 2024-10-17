{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  rustPlatform,
  libiconv,
}:

buildPythonPackage rec {
  pname = "unblob-native";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = "unblob-native";
    rev = "v${version}";
    hash = "sha256-XPmR0HYKl7/hXExJ3rJjXeaXB+PfZqgllkhfvBRj8r8=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = with rustPlatform; [
    maturinBuildHook
    cargoSetupHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  pythonImportsCheck = [ "unblob_native" ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Performance sensitive parts of Unblob.";
    homepage = "https://unblob.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vlaci ];
  };
}
