{ fetchFromGitLab
, installShellFiles
, lib
, python3
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nvd";
  version = "0.2.3";

  src = fetchFromGitLab {
    owner = "khumba";
    repo = "nvd";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-TmaXsyJLRkmIN9D77jOXd8fLj7kYPCBLg0AHIImAtgA=";
  };

  buildInputs = [
    python3
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall
    install -m555 -Dt $out/bin src/nvd
    installManPage src/nvd.1
    runHook postInstall
  '';

  meta = {
    description = "Nix/NixOS package version diff tool";
    homepage = "https://gitlab.com/khumba/nvd";
    license = lib.licenses.asl20;
    mainProgram = "nvd";
    maintainers = with lib.maintainers; [ khumba ];
    platforms = lib.platforms.all;
  };
})
