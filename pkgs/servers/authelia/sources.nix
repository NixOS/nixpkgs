{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.38.15";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-brgA485sst/jXjdhKrhQilreCYBhESro9j/63g8qQg4=";
  };
  vendorHash = "sha256-kSuIyL+6ue8voTzHTfnAYr9q4hUzIv/lkRopGSFaLv8=";
  pnpmDepsHash = "sha256-NAn7ExVmN6Sk2hOFHfBYvbNgXPQDhkFmvF1sZeTMomE=";
}
