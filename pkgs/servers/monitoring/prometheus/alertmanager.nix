{
  lib,
  go,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
}:

buildGoModule rec {
  pname = "alertmanager";
  version = "0.28.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "alertmanager";
    hash = "sha256-m8UbC9aSzUmoyfCxBNNSCeUQvnQqMlXrcOU0ygH9byE=";
  };

  vendorHash = "sha256-oIQ7sXBoYC/KSYk8Er8XEg6nf0vJ3kF80hysmInmdIc=";

  subPackages = [
    "cmd/alertmanager"
    "cmd/amtool"
  ];

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=${src.rev}"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.GoVersion=${lib.getVersion go}"
    ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    $out/bin/amtool --completion-script-bash > amtool.bash
    installShellCompletion amtool.bash
    $out/bin/amtool --completion-script-zsh > amtool.zsh
    installShellCompletion amtool.zsh
  '';

  passthru.tests = { inherit (nixosTests.prometheus) alertmanager; };

  meta = with lib; {
    description = "Alert dispatcher for the Prometheus monitoring system";
    homepage = "https://github.com/prometheus/alertmanager";
    changelog = "https://github.com/prometheus/alertmanager/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      benley
      fpletz
      globin
      Frostman
    ];
  };
}
