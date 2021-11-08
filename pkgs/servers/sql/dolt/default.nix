{ fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
  pname = "dolt";
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "liquidata-inc";
    repo = "dolt";
    rev = "v${version}";
    sha256 = "sha256-03cWsZEPjsUPyrGoU+RFkPb/BjYfLgO5sE50k9U1GjQ=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "sha256-7nmpsmisrtBxdLgC9mwSDYbjtbCrGl564+deC9CaYps=";

  doCheck = false;

  meta = with lib; {
    description = "Relational database with version control and CLI a-la Git";
    homepage = "https://github.com/liquidata-inc/dolt";
    license = licenses.asl20;
    maintainers = with maintainers; [ danbst ];
  };
}
