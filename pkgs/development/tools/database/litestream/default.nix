{ buildGoModule
, fetchFromGitHub
, lib
}:
buildGoModule rec {
  pname = "litestream";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OQ8j0FOUWU5TfCl4AZpmX5tuhtHAbrhvzT6ve6AJNn0=";
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
