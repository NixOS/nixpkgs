{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "q";
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "q";
    rev = "v${version}";
    sha256 = "sha256-kfuf0iwRYNxd9TfIIHvAqLxXjesQh7jC0evT9DQrrzQ=";
  };

  vendorHash = "sha256-6kdf+LwMrIjwC3uZHlMdpEHvonxKfr86PQaMOgzgYOc=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  doCheck = false; # tries to resolve DNS

  meta = {
    description = "Tiny and feature-rich command line DNS client with support for UDP, TCP, DoT, DoH, DoQ, and ODoH";
    homepage = "https://github.com/natesales/q";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.das_j ];
    mainProgram = "q";
  };
}
