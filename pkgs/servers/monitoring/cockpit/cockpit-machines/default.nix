{
  lib,
  stdenv,
  cockpit,
  nodejs,
  gettext,
  writeShellScriptBin,
  fetchFromGitHub,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cockpit-machines";
  version = "323";

  src = fetchFromGitHub {
    owner = "cockpit-project";
    repo = "cockpit-machines";
    rev = "refs/tags/${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-7JWUwYGnxPq+/B1MXu8cOMptvj8P1htlgF2yOtVaNH4=";

    postFetch = ''
      cp $out/node_modules/.package-lock.json $out/package-lock.json
    '';
  };

  buildInputs = [
    nodejs
    gettext
    (writeShellScriptBin "git" "true")
  ];

  cockpitSrc = cockpit.src;

  postPatch = ''
    mkdir -p pkg; cp -r $cockpitSrc/pkg/lib pkg
    mkdir -p test; cp -r $cockpitSrc/test/static-code test
    mkdir -p test; cp -r $cockpitSrc/test/common test

    substituteInPlace Makefile \
      --replace-fail '$(MAKE) package-lock.json' 'true' \
      --replace-fail '$(COCKPIT_REPO_FILES) | tar x' "" \
      --replace-fail '/usr/local' "$out"
    patchShebangs build.js
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Cockpit UI for virtual machines";
    homepage = "https://github.com/cockpit-project/cockpit-machines";
    changelog = "https://github.com/cockpit-project/cockpit-machines/releases/tag/${finalAttrs.version}";
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.lucasew ];
  };
})
