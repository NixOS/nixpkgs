{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "lovelace-card-mod";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "thomasloven";
    repo = "lovelace-card-mod";
    rev = "v${version}";
    hash = "sha256-BXyNXxCSEY0/AUD+6ggTvXPyPQYnAjkEgAVFmui6FAs=";
  };

  npmDepsHash = "sha256-afIJbUNKKCWckL60cpj4V2SMCOX0Kn56AkVK9t923D0=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp card-mod.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "card-mod.js";

  meta = with lib; {
    description = "Add CSS styles to (almost) any lovelace card";
    homepage = "https://github.com/thomasloven/lovelace-card-mod";
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
    platforms = platforms.all;
  };
}
