{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.4";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-OIf7Q84uWk2q+lTBQNHHO11QEl7FBGv2uNx+g2GNHE0=";
  };
  vendorHash = "sha256-Vndkts5e3NSdtTk3rVZSjfuGuafQ3eswoSLLFspXTIw=";
  pnpmDepsHash = "sha256-hA9STLJbFw5pFHx2Wi3X6JFsTvHzCMFVS3HEJApQ9zM=";
}
