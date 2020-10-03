{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gotify-cli";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0hgh1i8rdmf12qmk66cgksv8hz5qzkfbfb6cfmrkhbq765xkm4ir";
  };

  vendorSha256 = "1l47s0h0v4cgqcsm5008cknvfa4vnv6f7n43d8ga0xq5ikqqzmja";

  doCheck = false;

  postInstall = ''
    mv $out/bin/cli $out/bin/gotify
  '';

  buildFlagsArray = [
    "-ldflags=-X main.Version=${version} -X main.Commit=${version} -X main.BuildDate=1970-01-01"
  ];

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/gotify/cli";
    description = "A command line interface for pushing messages to gotify/server.";
    maintainers = with maintainers; [ ma27 ];
  };
}
