{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "bob";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "benchkram";
    repo = pname;
    rev = version;
    hash = "sha256-zmWfOLBb+GWw9v6LdCC7/WaP1Wz7UipPwqkmI1+rG8Q=";
  };

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  vendorHash = "sha256-S1XUgjdSVTWXehOLCxXcvj0SH12cxqvYadVlCw/saF4=";

  excludedPackages = [ "example/server-db" "test/e2e" "tui-example" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bob \
      --bash <($out/bin/bob completion) \
      --zsh <($out/bin/bob completion -z)
  '';

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "A build system for microservices";
    homepage = "https://bob.build";
    license = licenses.asl20;
    maintainers = with maintainers; [ zuzuleinen ];
  };
}
