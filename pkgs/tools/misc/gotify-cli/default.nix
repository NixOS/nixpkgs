{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gotify-cli";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-X41m7bCilDgnTMJy3ISz8g7dAtaz/lphwaCPZDGMDXk=";
  };

  vendorSha256 = "sha256-DvpdmURhOxDVFJiRtTGVw6u6y+s5XteT1owmdBJcKHA=";

  postInstall = ''
    mv $out/bin/cli $out/bin/gotify
  '';

  ldflags = [
    "-X main.Version=${version}" "-X main.Commit=${version}" "-X main.BuildDate=1970-01-01"
  ];

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/gotify/cli";
    description = "A command line interface for pushing messages to gotify/server";
    maintainers = with maintainers; [ ma27 ];
  };
}
