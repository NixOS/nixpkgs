{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
, nix-update-script
}:

buildGoModule rec {
  pname = "sing-box";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RSRhxsTbwYEho1+1ar2kX8gmQGOWIULlZcb84qNMMF8=";
  };

  vendorHash = "sha256-BdM+uK7ouCzDKWlifyaHK+GqbIpODVfjiXnyvmKKKrk=";

  tags = [
    "with_quic"
    "with_grpc"
    "with_dhcp"
    "with_wireguard"
    "with_shadowsocksr"
    "with_ech"
    "with_utls"
    "with_reality_server"
    "with_acme"
    "with_clash_api"
    "with_v2ray_api"
    "with_gvisor"
  ];

  subPackages = [
    "cmd/sing-box"
  ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-X=github.com/sagernet/sing-box/constant.Version=${version}"
  ];

  postInstall = let emulator = stdenv.hostPlatform.emulator buildPackages; in ''
    installShellCompletion --cmd sing-box \
      --bash <(${emulator} $out/bin/sing-box completion bash) \
      --fish <(${emulator} $out/bin/sing-box completion fish) \
      --zsh  <(${emulator} $out/bin/sing-box completion zsh )
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib;{
    homepage = "https://sing-box.sagernet.org";
    description = "The universal proxy platform";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
