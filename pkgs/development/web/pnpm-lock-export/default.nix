{ lib, buildNpmPackage, fetchFromGitHub }:
buildNpmPackage rec {
  pname = "pnpm-lock-export";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "cvent";
    repo = "pnpm-lock-export";
    rev = "v${version}";
    hash = "sha256-vS6AW3R4go1Fdr3PBOCnuN4JDrDkl1lWVF7q+q+xDGg=";
  };

  npmDepsHash = "sha256-3uW/lzB+UDhFQtRb3X8szNlgAWTcSdwVdtyZvLu+cjI=";

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
