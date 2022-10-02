{ buildGoModule
, fetchFromGitHub
, lib
}:
buildGoModule rec {
  pname = "litestream";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zs+Li8ylw+zexxuEkXX4qk7qslk23BLBcoHXRIuQNmU=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  vendorSha256 = "sha256-GiCvifdbWz+hH6aHACzlBpppNC5p24MHRWlbtKLIFhE=";

  meta = with lib; {
    description = "Streaming replication for SQLite";
    license = licenses.asl20;
    homepage = "https://litestream.io/";
    maintainers = with maintainers; [ fbrs ];
  };
}
