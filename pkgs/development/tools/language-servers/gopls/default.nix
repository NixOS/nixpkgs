{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    hash = "sha256-GgJ92nj94jRX3GnrOozG43wl8K/+UPOCbmp7Wt5E96U=";
  };

  modRoot = "gopls";
  vendorHash = "sha256-q7vWiXJAX4u8B4RyFc7kg1BvMCPaTBFOVkWXeE78Emo=";

  # https://github.com/golang/tools/blob/9ed98faa/gopls/main.go#L27-L30
  ldflags = [ "-X main.version=v${version}" ];

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    changelog = "https://github.com/golang/tools/releases/tag/${src.rev}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 rski SuperSandro2000 zimbatm ];
    mainProgram = "gopls";
  };
}
