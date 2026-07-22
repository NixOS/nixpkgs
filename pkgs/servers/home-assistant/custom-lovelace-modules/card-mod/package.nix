{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "lovelace-card-mod";
  version = "4.2.1-202604";

  src = fetchFromGitHub {
    owner = "thomasloven";
    repo = "lovelace-card-mod";
    rev = "v${version}";
    hash = "sha256-56nGxdA1RTkXZpcuQ6LOuRtGoBjTQtH2jKCN3omZCN0=";
  };

  npmDepsHash = "sha256-RZP3zWz7ZHob/QySF/6XTYOYuulGZUBQXG79fHHJfug=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp card-mod.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "card-mod.js";

  meta = {
    description = "Add CSS styles to (almost) any lovelace card";
    homepage = "https://github.com/thomasloven/lovelace-card-mod";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ k900 ];
    platforms = lib.platforms.all;
  };
}
