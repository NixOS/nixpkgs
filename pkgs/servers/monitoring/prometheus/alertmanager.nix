{ lib
, go
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "alertmanager";
  version = "0.26.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "alertmanager";
    hash = "sha256-DCVxXSgoa4PrW4qBBWa1SOPN1GwcJFERz7+itsCdtGI=";
  };

  vendorHash = "sha256-GCcoT7Db0bQf+IGUP54GdxRmHCp1k2261B3T2htmbjk=";

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
    changelog = "https://github.com/prometheus/alertmanager/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz globin Frostman ];
  };
}
