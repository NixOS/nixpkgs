{
  pkgs,
  stdenv,
  fetchPnpmDeps,
  nodejs,
  pnpm_10_latest,
  pnpmConfigHook,
}:
stdenv.mkDerivation {
  name = "pnpm-empty-lockfile";

  src = ./.;

  nativeBuildInputs = [
    pnpm_10_latest
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    pname = "pnpm-empty-lockfile";
    fetcherVersion = 3;
    pnpm = pnpm_10_latest;
    src = ./.;
    hash = "sha256-u0GOAX5B1f2ANWbOezScp/eKQRRZA/JoYfQ5zLrNip4=";
  };

  buildPhase = ''
    runHook preBuild
    touch $out
    runHook postBuild
  '';
}
