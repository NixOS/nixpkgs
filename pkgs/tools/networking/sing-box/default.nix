{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
}:

buildGoModule rec {
  pname = "sing-box";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CwXhCJo6Nq0dZaTcUetsSpvNKme1PN6pzMRX1QeY3gg=";
  };

  vendorHash = "sha256-cLaMtnTSmCZoPwfeQpWXCiFtmDm3vA6AD12H5h8Obhk=";

  tags = [
    "with_quic"
    "with_grpc"
    "with_wireguard"
    "with_shadowsocksr"
    "with_ech"
    "with_utls"
    "with_acme"
    "with_clash_api"
    "with_v2ray_api"
    "with_gvisor"
  ];

  subPackages = [
    "cmd/sing-box"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = let emulator = stdenv.hostPlatform.emulator buildPackages; in ''
    installShellCompletion --cmd sing-box \
      --bash <(${emulator} $out/bin/sing-box completion bash) \
      --fish <(${emulator} $out/bin/sing-box completion fish) \
      --zsh  <(${emulator} $out/bin/sing-box completion zsh )
  '';

  meta = with lib;{
    homepage = "https://sing-box.sagernet.org";
    description = "The universal proxy platform";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
