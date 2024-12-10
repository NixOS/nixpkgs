{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "gotify-cli";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-mOIomHNA20gKU7uh2Sf4NqqLNjNnD5hgOTUu9DuduiI=";
  };

  vendorHash = "sha256-ObJfUIy2GwogFm2/uCmShEXnIxDTqWWXCZPu9KJVFOA=";

  postInstall = ''
    mv $out/bin/cli $out/bin/gotify
  '';

  ldflags = [
    "-X main.Version=${version}"
    "-X main.Commit=${version}"
    "-X main.BuildDate=1970-01-01"
  ];

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/gotify/cli";
    description = "A command line interface for pushing messages to gotify/server";
    maintainers = with maintainers; [ ];
    mainProgram = "gotify";
  };
}
