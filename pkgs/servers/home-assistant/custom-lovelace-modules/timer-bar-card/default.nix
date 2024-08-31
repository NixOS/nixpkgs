{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "timer-bar-card";
  version = "1.30.2";

  src = fetchFromGitHub {
    owner = "rianadon";
    repo = "timer-bar-card";
    rev = "v${version}";
    hash = "sha256-o1OIbA1tRlnbWJ/p/wAUpeDnz/Wzu+GmUammJ6VFxHc=";
  };

  npmDepsHash = "sha256-x1HbOt9HW+zJAhHEDy2V5eYyLv4e3OrUbnzqeJasSng=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/timer-bar-card.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "timer-bar-card.js";

  meta = with lib; {
    description = "";
    homepage = "https://github.com/rianadon/timer-bar-card";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.all;
  };
}
