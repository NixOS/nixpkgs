{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "trash-card";
  version = "2.4.7";

  src = fetchFromGitHub {
    owner = "idaho";
    repo = "hassio-trash-card";
    tag = finalAttrs.version;
    hash = "sha256-Zf+iUcJs45eguaDJcuto6ccc/puormFajmYMc7Qpdsw=";
  };

  npmDepsHash = "sha256-zvsJASztDfecn+FRvQPmT0vIblaCD11eBM9LLq+VFrg=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/trashcard.js $out/

    runHook postInstall
  '';

  passthru.entrypoint = "trashcard.js";

  meta = {
    description = "Custom Home Assistant card that displays your current and upcoming trash collection schedule.";
    homepage = "https://github.com/idaho/hassio-trash-card";
    changelog = "https://github.com/idaho/hassio-trash-card/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.hchokshi ];
  };
})
