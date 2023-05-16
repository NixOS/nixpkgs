{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
<<<<<<< HEAD
, coreutils
, nix-update-script
, nixosTests
=======
, nix-update-script
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "sing-box";
<<<<<<< HEAD
  version = "1.4.2";
=======
  version = "1.2.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-OBLgAuZIqR+81rN886gIai8+uUxHDbOWnGz6jYZnGm8=";
  };

  vendorHash = "sha256-oDUjiMAG/vkSYS1c8lwqVlFzyvTIQrUSeJohHS9X9I0=";
=======
    hash = "sha256-RSRhxsTbwYEho1+1ar2kX8gmQGOWIULlZcb84qNMMF8=";
  };

  vendorHash = "sha256-BdM+uK7ouCzDKWlifyaHK+GqbIpODVfjiXnyvmKKKrk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD

    substituteInPlace release/config/sing-box{,@}.service \
      --replace "/usr/bin/sing-box" "$out/bin/sing-box" \
      --replace "/bin/kill" "${coreutils}/bin/kill"
    install -Dm444 -t "$out/lib/systemd/system/" release/config/sing-box{,@}.service
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) sing-box; };
  };
=======
  '';

  passthru.updateScript = nix-update-script { };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib;{
    homepage = "https://sing-box.sagernet.org";
    description = "The universal proxy platform";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
