{ lib, buildNpmPackage, fetchFromGitHub }:
buildNpmPackage rec {
  pname = "pnpm-lock-export";
  version = "unstable-2023-07-31";

  src = fetchFromGitHub {
    owner = "adamcstephens";
    repo = "pnpm-lock-export";
    rev = "cc03755d6718a9c0d268d0f375907328ac15dc92";
    hash = "sha256-9OlFgmdKjvz4pB36Wm/fUAQDsD8zs32OSA3m2IAgrH8=";
  };

  npmDepsHash = "sha256-nqkH7vFD78YvYr9Klguk2o7qHr5wr3ZjaywUKRRRjJo=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    # Make the executable get installed to `bin/` instead of `bin/@cvent`
    substituteInPlace package.json --replace "@cvent/pnpm-lock-export" "pnpm-lock-export"
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "A utility for converting pnpm-lock.yaml to other lockfile formats";
    homepage = "https://github.com/cvent/pnpm-lock-export";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
