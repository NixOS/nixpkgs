{ lib, go, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "alertmanager";
  version = "0.23.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "alertmanager";
    sha256 = "sha256-06mKgWUyw5jsjKiRXQ9/oqHvFdkY2nS9Z3eW60lTNbU=";
  };

  vendorSha256 = "sha256-zJvzCC7Vn5repWssyDuGtoUSZC2ojQhMqDX5Orr0ST0=";

  subPackages = [ "cmd/alertmanager" "cmd/amtool" ];

  ldflags = let t = "github.com/prometheus/common/version"; in [
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

  meta = with lib; {
    description = "Alert dispatcher for the Prometheus monitoring system";
    homepage = "https://github.com/prometheus/alertmanager";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz globin Frostman ];
    platforms = platforms.unix;
  };
}
