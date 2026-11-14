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
    hash = "sha256-iPfLZ87+vTwP5MAbielbP+1IayN9L0N26yLmggtKeVM=";
  };

  npmDepsHash = "sha256-nFLWixY6gt6qNarg8u9lpXb6IBN9RJPbGFeOAL5q1Yk=";

  makeCacheWritable = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/timer-bar-card.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "timer-bar-card.js";

  meta = with lib; {
    description = "A progress bar display for Home Assistant timers";
    homepage = "https://github.com/rianadon/timer-bar-card";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.all;
  };
}
