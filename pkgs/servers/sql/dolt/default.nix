{ fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
  pname = "dolt";
  version = "0.37.4";

  src = fetchFromGitHub {
    owner = "liquidata-inc";
    repo = "dolt";
    rev = "v${version}";
    sha256 = "sha256-cKX8idMmh9hQVPjO8rJWlp1nhtnzwwlLkelNw+LLBag=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "sha256-vaYCo+jvw3qcLQ63oA8tq6G6Gxq50VTxK6IMBcEZXqs=";

  doCheck = false;

  meta = with lib; {
    description = "Relational database with version control and CLI a-la Git";
    homepage = "https://github.com/liquidata-inc/dolt";
    license = licenses.asl20;
    maintainers = with maintainers; [ danbst ];
  };
}
