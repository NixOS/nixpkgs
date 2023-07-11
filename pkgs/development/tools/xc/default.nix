{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xc";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "joerdav";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Dc7MVn9hF2HtXqMvWQ5UsLQW5ZKcFKt7AHcXdiWDs1I=";
  };

  vendorHash = "sha256-hCdIO377LiXFKz0GfCmAADTPfoatk8YWzki7lVP3yLw=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  meta = with lib; {
    description = "Markdown defined task runner";
    homepage = "https://xcfile.dev/";
    changelog = "https://github.com/joerdav/xc/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda joerdav ];
  };
}
