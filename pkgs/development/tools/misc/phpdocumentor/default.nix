{ lib, fetchFromGitHub, php, makeWrapper }:

php.buildComposerProject (finalAttrs: {
  pname = "phpDocumentor";
  version = "3.3.1";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchFromGitHub {
    owner = "phpDocumentor";
    repo = "phpDocumentor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aJjcfyQFBXBg2GtJOxe9MgRZrYzqVoPaknXyoso+c4M=";
  };

  vendorHash = "sha256-nqVs7Tr7MAXLT5HvQQ4hBDD0eKoSoLX+m1WlEzXxGGg=";

  patches = [
    # Backported patch from https://github.com/phpDocumentor/phpDocumentor/pull/3518
    # Needs to be removed at the next version probably.
    ./support-env-vars.patch
  ];

  installPhase = ''
    runHook preInstall

    wrapProgram "$out/bin/phpdoc" \
      --set-default APP_CACHE_DIR /tmp \
      --set-default APP_LOG_DIR /tmp/log

    runHook postInstall
  '';

  meta = {
    description = "PHP documentation generator";
    license = lib.licenses.mit;
    homepage = "https://phpdoc.org";
    changelog = "https://github.com/phpDocumentor/phpDocumentor/releases/tag/v${finalAttrs.version}";
    maintainers = lib.teams.php.members;
  };
})
