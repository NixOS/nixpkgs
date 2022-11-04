{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cassowary";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "rogerwelin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eZ61LIDMv+G7jnSrEFCsm6MP5+BpzJW+OnI9bqAZ5hw=";
  };

  vendorSha256 = "sha256-5U/YqqNfZfLZLEwuRh4mXACr9Gj7iOrLQRSLC/b8ZRw=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/rogerwelin/cassowary";
    description = "Modern cross-platform HTTP load-testing tool written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ hugoreeves ];
    platforms = platforms.unix;
  };
}
