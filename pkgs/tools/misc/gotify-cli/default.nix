{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gotify-cli";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-dkG2dzt2PvIio+1/yx8Ihui6WjwvbBHlhJcoXADZBl4=";
  };

  vendorSha256 = "sha256-0Utc1rGaFpDXhxMZ8bwMCYbfAyqNiQKtyqZMdhBujMs=";

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
    mainProgram = "gotify";
  };
}
