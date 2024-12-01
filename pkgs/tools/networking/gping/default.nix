{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  iputils,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "gping-v${version}";
    hash = "sha256-JZMgbCwEGfngCQVmuZX1tu3he/f/TBLitcP/Ea3S6yI=";
  };

  cargoHash = "sha256-I9rcC2sotrdHMCCiDgfycKRnJxZLuA5OLZPZC0zFiLc=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [ iputils ];

  postInstall = ''
    installManPage gping.1
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = [ "--version" ];

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    changelog = "https://github.com/orf/gping/releases/tag/gping-v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ cafkafk ];
    mainProgram = "gping";
  };
}
