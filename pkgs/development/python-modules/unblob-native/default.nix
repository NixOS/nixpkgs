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
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = "unblob-native";
    tag = "v${version}";
    hash = "sha256-jpaBxKuQNfU0I3kCs67mM5dzGURSSHvqymhk43P7xXk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-K2QTf4OlP4AH2JJiJ6r8PRkInSOQdIBQcSvY5tWr4mw=";
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
