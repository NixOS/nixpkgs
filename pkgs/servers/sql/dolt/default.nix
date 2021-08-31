{ fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
  pname = "dolt";
  version = "0.27.4";

  src = fetchFromGitHub {
    owner = "liquidata-inc";
    repo = "dolt";
    rev = "v${version}";
    sha256 = "sha256-q3zs402E3mqvxAuf/ll/ao9/c9NOWR7uYJMbieFXS1U=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "sha256-zF7pofbYrVzEiW6zttyePuEWueqKRKclc0WrYwb1bCU=";

  doCheck = false;

  meta = with lib; {
    description = "Relational database with version control and CLI a-la Git";
    homepage = "https://github.com/liquidata-inc/dolt";
    license = licenses.asl20;
    maintainers = with maintainers; [ danbst ];
  };
}
