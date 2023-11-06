{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, tbls
}:

buildGoModule rec {
  pname = "tbls";
  version = "1.70.2";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "tbls";
    rev = "v${version}";
    hash = "sha256-LSICkg99veFHLmdcQZmnyfTbdqx7k2XI13W7Cjuj3qA=";
  };

  vendorHash = "sha256-84h+LQzk/xy/Gapy7IxB8IPvsVGRsJP7udd9HhLskew=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

  CGO_CFLAGS = [ "-Wno-format-security" ];

  preCheck = ''
    # Remove tests that require additional services.
    rm -f \
       datasource/*_test.go \
       drivers/*/*_test.go
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tbls \
      --bash <($out/bin/tbls completion bash) \
      --fish <($out/bin/tbls completion fish) \
      --zsh <($out/bin/tbls completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = tbls;
    command = "tbls version";
    inherit version;
  };

  meta = with lib; {
    description = "A tool to generate documentation based on a database structure";
    homepage = "https://github.com/k1LoW/tbls";
    changelog = "https://github.com/k1LoW/tbls/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
