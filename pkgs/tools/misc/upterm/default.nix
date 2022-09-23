{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, nixosTests
}:

buildGoModule rec {
  pname = "upterm";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "owenthereal";
    repo = "upterm";
    rev = "v${version}";
    hash = "sha256-ywwqX4aw9vc2kptYZisArTpdz7Cf49Z0jMdP90KXejs=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/upterm" "cmd/uptermd" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    # force go to build for build arch rather than host arch during cross-compiling
    CGO_ENABLED=0 GOOS= GOARCH= go run cmd/gendoc/main.go
    installManPage etc/man/man*/*
    installShellCompletion --bash --name upterm.bash etc/completion/upterm.bash_completion.sh
    installShellCompletion --zsh --name _upterm etc/completion/upterm.zsh_completion
  '';

  doCheck = true;

  passthru.tests = { inherit (nixosTests) uptermd; };

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Secure terminal-session sharing";
    homepage = "https://upterm.dev";
    license = licenses.asl20;
    maintainers = with maintainers; [ hax404 ];
  };
}
