{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "httpref";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "dnnrly";
    repo = "httpref";
    rev = "v${version}";
    hash = "sha256-T5fR9cyqsM6Kw6kFqZedoSxyvFkkxNpuErscwiUTMa0=";
  };

  vendorHash = "sha256-9Ei4Lfll79f/+iuO5KesUMaTgkS9nq+1tma/dhOZ7Qw=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command line, offline, access to HTTP status code, common header, and port references";
    mainProgram = "httpref";
    homepage = "https://github.com/dnnrly/httpref";
    changelog = "https://github.com/dnnrly/httpref/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
