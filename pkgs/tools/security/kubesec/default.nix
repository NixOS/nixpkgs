{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubesec";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rv5qywh8107rqdly1x7wkb6dljalyn9abrkm12bxa7cqscp9b4z";
  };

  vendorSha256 = "0xngnx67giwp0g7c19xhb6kmc9m3bjlwk2wwp9bn9vwkmss3ysyp";

  # Tests wants to download additional files
  doCheck = false;

  meta = with lib; {
    description = "Security risk analysis tool for Kubernetes resources";
    homepage = "https://github.com/controlplaneio/kubesec";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
