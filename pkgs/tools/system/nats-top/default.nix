{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nats-top";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b1hpnq8m1xfrn58ammmnx6lmhk319m8z4xjxgckz7wvy2fbzw0n";
  };

  vendorSha256 = "1a48p9gx5zdc340ma6cqakhi6f3lw9b0kz2597j1jcsk2qb7s581";

  meta = with lib; {
    description = "top-like tool for monitoring NATS servers";
    homepage = "https://github.com/nats-io/nats-top";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
