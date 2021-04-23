{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.0.22";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = version;
    sha256 = "1qc6lpgl878kc316z10x59px6jyfzdwsj7fdr8k4ayln0lplvbq3";
  };

  vendorSha256 = "1a9d7hqj43qdh0h7pc5wckqshi8lacf6m2107wymzzz62j1msy26";

  meta = with lib; {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
