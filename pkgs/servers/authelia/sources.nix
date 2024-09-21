{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.38.10";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-ugLOhFYpdio1XG0OXCWHY78wfRJOIDizY1Mvd4vfp18=";
  };
  vendorHash = "sha256-0PkS+mqDPnb4OixWttIIUqX74qzW63OZP+DMMbuClHg=";
  pnpmDepsHash = "sha256-K+9yeQGXhqbOS/zwPphYElAEmeYkQ6A9JKgkcaxHAw4=";
}
