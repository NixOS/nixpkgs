{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "zx";
  version = "7.2.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zx";
    rev = version;
    hash = "sha256-YMfecNazmL8J+f80FdIRvr2upQ7VgXSkQQnm8z0Swhw=";
  };

  npmDepsHash = "sha256-ywNd2LGjM35ecW4dnj0oNwdSX2CRy8i9OGKPIdI0UEQ=";

  meta = {
    description = "Tool for writing scripts using JavaScript";
    homepage = "https://github.com/google/zx";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hlolli ];
    mainProgram = "zx";
  };
}
