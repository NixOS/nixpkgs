{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "vacuum-card";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "denysdovhan";
    repo = "vacuum-card";
    rev = "v${version}";
    hash = "sha256-egWseYspxm+zkfFwTEBYQfBox3sswYMuOYqU6oEQTb4=";
  };

  npmDepsHash = "sha256-dfsKBTJV1QC8pmb/EIh4n5I9CDnOjy7+sPwQA/eLEi0=";

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
