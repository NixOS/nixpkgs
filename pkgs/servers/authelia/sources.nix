{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.10";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-v6KxDfl/dG4FEC/6V2io5jYlS6FY/WemnZJ7tpikpyM=";
  };
  vendorHash = "sha256-Gvk5AX0kyIYyFmgvb/TGCIEycTjtdxNLHk9sbrU5Ybw=";
  pnpmDepsHash = "sha256-0evGB5UYphBCrVN3/hJfNXJvDGSz77Cm/s7XW7JNU/o=";
}
