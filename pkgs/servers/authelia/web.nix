{
  stdenv,
  nodejs,
  pnpm,
  fetchFromGitHub,
}:

let
  inherit (import ./sources.nix { inherit fetchFromGitHub; })
    pname
    version
    src
    pnpmDepsHash
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "${pname}-web";
  inherit src version;

  sourceRoot = "${finalAttrs.src.name}/web";

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    hash = pnpmDepsHash;
  };

  postPatch = ''
    substituteInPlace ./vite.config.ts \
      --replace 'outDir: "../internal/server/public_html"' 'outDir: "dist"'
  '';

  postBuild = ''
    pnpm run build
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    mv dist $out/share/authelia-web

    runHook postInstall
  '';
})
