{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs,
}:
let
  pnpm = pnpm_10;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lovelace-expander-card";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "Alia5";
    repo = "lovelace-expander-card";
    tag = finalAttrs.version;
    hash = "sha256-D76gZR2yEZJrfaesomrpyMg/OPRfVjdDUwcl0EqqNmg=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-L+lLJICyh7BhW9CF0+yhYginUx95EQ4de9gXQl8XmOo=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm
    nodejs
  ];

  # Upstream tries to get the version via git; since Nix' fetchers don't give us
  # the .git directory this'll fail, so we provide it manually
  postPatch = ''
    substituteInPlace package.json \
      --replace-fail 'VERSION=$(git describe --tags)' 'VERSION=${finalAttrs.version}'
  '';

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp dist/*.js "$out"

    runHook postInstall
  '';

  meta = {
    description = "Home Assistant Lovelace card that wraps other cards in a collapsible expander";
    homepage = "https://github.com/Alia5/lovelace-expander-card";
    changelog = "https://github.com/Alia5/lovelace-expander-card/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kilyanni ];
    platforms = lib.platforms.all;
  };
})
