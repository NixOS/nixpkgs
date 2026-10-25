{
  pkgs,
  stdenv,
  fetchPnpmDeps,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
}:
stdenv.mkDerivation {
  name = "pnpm-empty-lockfile";

  src = ./.;

  nativeBuildInputs = [
    pnpm_10
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    pname = "pnpm-empty-lockfile";
    fetcherVersion = 3;
    pnpm = pnpm_10;
    src = ./.;
    hash = "sha256-u0GOAX5B1f2ANWbOezScp/eKQRRZA/JoYfQ5zLrNip4=";
  };

  buildPhase = ''
    runHook preBuild
    touch $out
    runHook postBuild
  '';
}
