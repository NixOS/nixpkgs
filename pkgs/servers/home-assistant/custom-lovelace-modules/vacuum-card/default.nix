{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "vacuum-card";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "denysdovhan";
    repo = "vacuum-card";
    rev = "v${version}";
    hash = "sha256-NJeD6YhXmNNBuhRWjK74sTrxzXyGSbehm5lz05sNA3Y=";
  };

  npmDepsHash = "sha256-x+pq58chBSgFVGr9Xtka5/MH/AHV0zMpyKfA/kEEXBM=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/vacuum-card.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "vacuum-card.js";

  meta = with lib; {
    description = "Vacuum cleaner card for Home Assistant Lovelace UI";
    homepage = "https://github.com/denysdovhan/vacuum-card";
    license = licenses.mit;
    maintainers = with maintainers; [ baksa ];
    platforms = platforms.all;
  };
}
