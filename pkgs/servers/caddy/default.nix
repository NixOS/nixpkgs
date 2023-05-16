{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
, caddy
, testers
, installShellFiles
}:
let
<<<<<<< HEAD
  version = "2.7.4";
=======
  version = "2.6.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  dist = fetchFromGitHub {
    owner = "caddyserver";
    repo = "dist";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-8wdSRAONIPYe6kC948xgAGHm9cePbXsOBp9gzeDI0AI=";
=======
    hash = "sha256-SJO1q4g9uyyky9ZYSiqXJgNIvyxT5RjrpYd20YDx8ec=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
in
buildGoModule {
  pname = "caddy";
  inherit version;

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = "caddy";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-oZSAY7vS8ersnj3vUtxj/qKlLvNvNL2RQHrNr4Cc60k=";
  };

  vendorHash = "sha256-CnWAVGPrHIjWJgh4LwJvrjQJp/Pz92QHdANXZIcIhg8=";
=======
    hash = "sha256-3a3+nFHmGONvL/TyQRqgJtrSDIn0zdGy9YwhZP17mU0=";
  };

  vendorHash = "sha256-toi6efYZobjDV3YPT9seE/WZAzNaxgb1ioVG4txcuXM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/caddy" ];

  ldflags = [
    "-s" "-w"
    "-X github.com/caddyserver/caddy/v2.CustomVersion=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    install -Dm644 ${dist}/init/caddy.service ${dist}/init/caddy-api.service -t $out/lib/systemd/system

    substituteInPlace $out/lib/systemd/system/caddy.service --replace "/usr/bin/caddy" "$out/bin/caddy"
    substituteInPlace $out/lib/systemd/system/caddy-api.service --replace "/usr/bin/caddy" "$out/bin/caddy"

    $out/bin/caddy manpage --directory manpages
    installManPage manpages/*

<<<<<<< HEAD
    installShellCompletion --cmd caddy \
=======
    installShellCompletion --cmd metal \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --bash <($out/bin/caddy completion bash) \
      --fish <($out/bin/caddy completion fish) \
      --zsh <($out/bin/caddy completion zsh)
  '';

  passthru.tests = {
    inherit (nixosTests) caddy;
    version = testers.testVersion {
      command = "${caddy}/bin/caddy version";
      package = caddy;
    };
  };

  meta = with lib; {
    homepage = "https://caddyserver.com";
    description = "Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ Br1ght0ne emilylange techknowlogick ];
=======
    maintainers = with maintainers; [ Br1ght0ne indeednotjames techknowlogick ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
