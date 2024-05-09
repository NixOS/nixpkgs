{ lib, buildNpmPackage, fetchFromGitHub }:
buildNpmPackage rec {
  pname = "pnpm-lock-export";
  version = "unstable-2023-07-31";

  src = fetchFromGitHub {
    owner = "adamcstephens";
    repo = "pnpm-lock-export";
    rev = "a7ede6d96f9d273b6b495718b85ed40f432c34ba";
    hash = "sha256-RQGyUQOyFZW7UbIPRRlZu8FKcZN2kO0DcPfB8uLFFg4=";
  };

  npmDepsHash = "sha256-1VTXzlafuI+dU4k1JyZPVI5/5h0gt/eggPPXKYxKsbs=";

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
    mainProgram = "pnpm-lock-export";
    homepage = "https://github.com/cvent/pnpm-lock-export";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
