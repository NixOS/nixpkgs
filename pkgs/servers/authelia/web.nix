{
  stdenv,
  nodejs,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    pnpmConfigHook
    pnpm
  ];

  pnpmDeps = fetchPnpmDeps {
=======
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
<<<<<<< HEAD
    inherit pnpm; # This may be different than pkgs.pnpm
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetcherVersion = 1;
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
