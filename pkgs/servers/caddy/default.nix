{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
, caddy
, testers
, installShellFiles
}:
let
  version = "2.6.1";
  dist = fetchFromGitHub {
    owner = "caddyserver";
    repo = "dist";
    rev = "v${version}";
    sha256 = "sha256-EXs+LNb87RWkmSWvs8nZIVqRJMutn+ntR241gqI7CUg=";
  };
in
buildGoModule {
  pname = "caddy";
  inherit version;

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = "caddy";
    rev = "v${version}";
    sha256 = "sha256-Z8MiMhXH1er+uYvmDQiamF/jSxHbTMwjo61qbH0ioEo=";
  };

  vendorSha256 = "sha256-6UTErIPB/z4RfndPSLKFJDFweLB3ax8WxEDA+3G5asI=";

  patches = [
    ./inject_version.diff
  ];

  subPackages = [ "cmd/caddy" ];

  ldflags = [
    "-s" "-w"
    "-X github.com/caddyserver/caddy/v2.ShortVersion=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    install -Dm644 ${dist}/init/caddy.service ${dist}/init/caddy-api.service -t $out/lib/systemd/system

    substituteInPlace $out/lib/systemd/system/caddy.service --replace "/usr/bin/caddy" "$out/bin/caddy"
    substituteInPlace $out/lib/systemd/system/caddy-api.service --replace "/usr/bin/caddy" "$out/bin/caddy"

    installShellCompletion --cmd metal \
      --bash <($out/bin/caddy completion bash) \
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
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne techknowlogick ];
  };
}
