{
  lib,
  stdenvNoCC,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  libiconv,
}:

buildPythonPackage rec {
  pname = "unblob-native";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = "unblob-native";
    tag = "v${version}";
    hash = "sha256-11eMU7eplvZS1OS34fhbD8g1dOwOUCc8Xk1dEZI8dyU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-NjyxAZH4A46llIjEQO0X+IiwpS74RPY9wLujsDr7OxA=";
  };

  nativeBuildInputs = with rustPlatform; [
    maturinBuildHook
    cargoSetupHook
  ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isDarwin [ libiconv ];

  pythonImportsCheck = [ "unblob_native" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Performance sensitive parts of Unblob";
    homepage = "https://unblob.org";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ vlaci ];
  };
}
