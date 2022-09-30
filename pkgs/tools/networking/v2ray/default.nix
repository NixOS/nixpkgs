{ lib, fetchFromGitHub, symlinkJoin, buildGoModule, makeWrapper, nixosTests
, nix-update-script
, v2ray-geoip, v2ray-domain-list-community
, assets ? [ v2ray-geoip v2ray-domain-list-community ]
}:

buildGoModule rec {
  pname = "v2ray-core";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "v2ray-core";
    rev = "v${version}";
    hash = "sha256-87BtyaJN6qbinZQ+6MAwaK62YzbVnncj4qnEErG5tfA=";
  };

  # `nix-update` doesn't support `vendorHash` yet.
  # https://github.com/Mic92/nix-update/pull/95
  vendorSha256 = "sha256-RuDCAgTzqwe5fUwa9ce2wRx4FPT8siRLbP7mU8/jg/Y=";

  ldflags = [ "-s" "-w" "-buildid=" ];

  subPackages = [ "main" ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm555 "$GOPATH"/bin/main $out/bin/v2ray
    install -Dm444 release/config/systemd/system/v2ray{,@}.service -t $out/lib/systemd/system
    install -Dm444 release/config/*.json -t $out/etc/v2ray
    runHook postInstall
  '';

  assetsDrv = symlinkJoin {
    name = "v2ray-assets";
    paths = assets;
  };

  postFixup = ''
    wrapProgram $out/bin/v2ray \
      --suffix XDG_DATA_DIRS : $assetsDrv/share
    substituteInPlace $out/lib/systemd/system/*.service \
      --replace User=nobody DynamicUser=yes \
      --replace /usr/local/bin/ $out/bin/ \
      --replace /usr/local/etc/ /etc/
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "v2ray";
    };
    tests.simple-vmess-proxy-test = nixosTests.v2ray;
  };

  meta = {
    homepage = "https://www.v2fly.org/en_US/";
    description = "A platform for building proxies to bypass network restrictions";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ servalcatty ];
  };
}
