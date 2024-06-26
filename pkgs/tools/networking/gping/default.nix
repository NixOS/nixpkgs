{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  libiconv,
  Security,
  iputils,
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "gping-v${version}";
    hash = "sha256-hCqjbJt0dHuvFsWEF/WgLEPY2xws71wFGdhzThYOOvA=";
  };

  cargoHash = "sha256-3jpQ8ANg9WYK1Q5Hph6fK442e5f9dsLQbTMBEwTaENc=";

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Security
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = lib.optionals stdenv.isLinux [ iputils ];

  postInstall = ''
    installManPage gping.1
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/gping --version | grep "${version}"
  '';

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    changelog = "https://github.com/orf/gping/releases/tag/gping-v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ cafkafk ];
    mainProgram = "gping";
  };
}
