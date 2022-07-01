{ lib, go, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "alertmanager";
  version = "0.24.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "alertmanager";
    sha256 = "sha256-hoCE0wD9/Sh/oBce7kCg/wG44FmMs6dAKnEYP+2sH0w=";
  };

  vendorSha256 = "sha256-ePb9qdCTEHHIV6JlbrBlaZjD5APwQuoGloO88W5S7Oc=";

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
