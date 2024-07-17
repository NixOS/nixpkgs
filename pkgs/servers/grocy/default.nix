{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  php,
  yarn,
  fixup-yarn-lock,
  nixosTests,
}:

php.buildComposerProject (finalAttrs: {
  pname = "grocy";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "grocy";
    repo = "grocy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aX3DMy9Jv8rNp1/VIvUtNXYXGBrCgBMs5GsDf4XXSj0=";
  };

  vendorHash = "sha256-KaYvA0Rd4pd1s/L8QbVUgkE+SjH+jv4+6RvIaGOpews=";

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-UvWY8+qSRvzJbm7z3CmLyeUHxemzNUB7dHYP95ZVtcI=";
  };

  nativeBuildInputs = [
    yarn
    fixup-yarn-lock
  ];

  # Upstream composer.json file is missing the name, description and license fields
  composerStrictValidation = false;

  # NOTE: if patches are created from a git checkout, those should be modified
  # with `unix2dos` to make sure those apply here.
  patches = [
    ./0001-Define-configs-with-env-vars.patch
    ./0002-Remove-check-for-config-file-as-it-s-stored-in-etc-g.patch
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --no-progress --non-interactive

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    mv $out/share/php/grocy/* $out
    rm -r $out/share

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) grocy;
  };

  meta = with lib; {
    license = licenses.mit;
    maintainers = with maintainers; [ n0emis ];
    description = "ERP beyond your fridge - grocy is a web-based self-hosted groceries & household management solution for your home";
    homepage = "https://grocy.info/";
  };
})
