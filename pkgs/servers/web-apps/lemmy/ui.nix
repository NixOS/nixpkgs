{
  lib,
  stdenvNoCC,
  libsass,
  nodejs,
  pnpm_9,
  fetchFromGitHub,
  nixosTests,
  vips,
}:

let
  pinData = lib.importJSON ./pin.json;
in

stdenvNoCC.mkDerivation (finalAttrs: {

  pname = "lemmy-ui";
  version = pinData.uiVersion;

  src = fetchFromGitHub {
    owner = "LemmyNet";
    repo = "lemmy-ui";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = pinData.uiHash;
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
  ];

  buildInputs = [
    libsass
    vips
  ];

  extraBuildInputs = [ libsass ];
  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = pinData.uiPNPMDepsHash;
  };

  buildPhase = ''
    runHook preBuild

    pnpm run prebuild:prod
    # Required to pass a custom value for COMMIT_HASH, as the normal
    # `pnpm build:prod` tries to derive its value by running `git`.
    # This value is only injected into the templated asset URLs for cache invalidation,
    # so we don't really need a commit hash here, just a value that changes on every
    # update.
    pnpm exec webpack --env COMMIT_HASH="${finalAttrs.version}" --mode=production

    runHook postBuild
  '';

  preInstall = ''
    mkdir $out
    cp -R ./dist $out
    cp -R ./node_modules $out
  '';

  preFixup = ''
    find $out -name libvips-cpp.so.42 -print0 | while read -d $'\0' libvips; do
      echo replacing libvips at $libvips
      rm $libvips
      ln -s ${lib.getLib vips}/lib/libvips-cpp.so.42 $libvips
    done
  '';

  distPhase = "true";

  passthru = {
    updateScript = ./update.py;
    tests.lemmy-ui = nixosTests.lemmy;
  };

  meta = {
    description = "Building a federated alternative to reddit in rust";
    homepage = "https://join-lemmy.org/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      happysalada
      billewanick
      georgyo
    ];
    inherit (nodejs.meta) platforms;
  };
})
