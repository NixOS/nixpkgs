{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
, coreutils
, nix-update-script
, nixosTests
}:

buildGoModule rec {
  pname = "sing-box";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Vyp8AlcHhkKitcSaQ3ecjfevjSYPUZQercRJsjaXgTk=";
  };

  vendorHash = "sha256-Lcrc24GfkVfabMnT15scaoQFSiKJ3umbs0rAMDxtQR8=";

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

    substituteInPlace release/config/sing-box{,@}.service \
      --replace "/usr/bin/sing-box" "$out/bin/sing-box" \
      --replace "/bin/kill" "${coreutils}/bin/kill"
    install -Dm444 -t "$out/lib/systemd/system/" release/config/sing-box{,@}.service
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) sing-box; };
  };

  meta = with lib;{
    homepage = "https://sing-box.sagernet.org";
    description = "The universal proxy platform";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
