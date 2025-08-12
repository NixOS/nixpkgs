{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "lovelace-card-mod";
  version = "3.4.5";

  src = fetchFromGitHub {
    owner = "thomasloven";
    repo = "lovelace-card-mod";
    rev = "v${version}";
    hash = "sha256-yd07C3/tpnoclrztWBAVwU6Ic2a4hY45xcjmgSp/uZA=";
  };

  npmDepsHash = "sha256-IjN0sBWa6y/j0x5XRvDU0F6kA9RTfKFlVsnqwBkgx2Q=";

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
