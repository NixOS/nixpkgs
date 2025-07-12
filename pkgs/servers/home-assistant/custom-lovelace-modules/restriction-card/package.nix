{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "restriction-card";
  version = "1.2.19";

  src = fetchFromGitHub {
    owner = "iantrich";
    repo = "restriction-card";
    tag = "${finalAttrs.version}";
    hash = "sha256-2scUSEpDPrMoos/QuOqXARAf1IL8P4gJaga7LRQ/67U=";
  };

  npmDepsHash = "sha256-9Hz+7Q4i5baIWxVIo6e8d5isvZWnJW2947q5Uk0Gm9w=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -m0644 dist/restriction-card.js $out

    runHook postInstall
  '';

  meta = {
    description = "🔒 Apply restrictions to Lovelace cards";
    homepage = "https://github.com/iantrich/restriction-card";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jfly ];
  };
})
