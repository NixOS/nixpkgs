{ buildGoModule
, fetchFromGitHub
, lib
}:
buildGoModule rec {
  pname = "litestream";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IEdTLf+fEp19FhwL3IaGT9HGKQoa6HwFox2gf0lvFu4=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  vendorSha256 = "sha256-ScG8cukUuChOvN9r0HvVJsYnu1X9DSO7aD32iu55jIM=";

  meta = with lib; {
    description = "Streaming replication for SQLite";
    license = licenses.asl20;
    homepage = "https://litestream.io/";
    maintainers = with maintainers; [ fbrs ];
  };
}
