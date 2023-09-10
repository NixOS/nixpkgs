{ buildGoModule
, fetchFromGitHub
, lib
}:
buildGoModule rec {
  pname = "litestream";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-03gGGx8RZEK2RrToN30gkIlHss/e3UcSi3AmMh9twDU=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  vendorHash = "sha256-sYIY3Z3VrCqbjEbQtEY7q6Jljg8jMoa2qWEB/IkDjzM=";

  meta = with lib; {
    description = "Streaming replication for SQLite";
    license = licenses.asl20;
    homepage = "https://litestream.io/";
    maintainers = with maintainers; [ fbrs ];
  };
}
