{
  callPackage,
  fetchPnpmDeps,
  nodejs,
  pnpm,
  pnpmConfigHook,
  stdenv,
}:
let
  common = callPackage ./common.nix { };
in
stdenv.mkDerivation rec {
  pname = "gradient-frontend";

  inherit (common) src version;

  sourceRoot = "${common.src.name}/frontend";

  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    fetcherVersion = 3;
    hash = common.pnpmDepsHash;
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/gradient-frontend
    cp -r dist/gradient-frontend/browser/* $out/share/gradient-frontend/

    runHook postInstall
  '';

  meta = common.meta // {
    description = "frontend for gradient, a nix-based continuous integration system, as an alternative to Hydra";
  };
}
