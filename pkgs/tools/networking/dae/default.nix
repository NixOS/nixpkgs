{ lib
, clang
, fetchFromGitHub
, symlinkJoin
, buildGoModule
, makeWrapper
, v2ray-geoip
, v2ray-domain-list-community
}:
buildGoModule rec {
  pname = "dae";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = "dae";
    rev = "v${version}";
    hash = "sha256-Fk3xpQ8xuZMPulMFZb5fnN0Tisk13XRx49vBN5coanQ=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-sqcImm5BYTiUnBmcpWWMR1TuV877VE5gZ8Oth8AxjSg=";

  proxyVendor = true;

  nativeBuildInputs = [ clang makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/daeuniverse/dae/cmd.Version=${version}"
    "-X github.com/daeuniverse/dae/common/consts.MaxMatchSetLen_=64"
  ];

  preBuild = ''
    make CFLAGS="-D__REMOVE_BPF_PRINTK -fno-stack-protector" \
    NOSTRIP=y \
    ebpf
  '';

  # network required
  doCheck = false;

  assetsDrv = symlinkJoin {
    name = "dae-assets";
    paths = [ v2ray-geoip v2ray-domain-list-community ];
  };

  postInstall = ''
    install -Dm444 install/dae.service $out/lib/systemd/system/dae.service
    wrapProgram $out/bin/dae \
      --suffix DAE_LOCATION_ASSET : $assetsDrv/share/v2ray
    substituteInPlace $out/lib/systemd/system/dae.service \
      --replace /usr/bin/dae $out/bin/dae
  '';

  meta = with lib; {
    description = "A Linux high-performance transparent proxy solution based on eBPF";
    homepage = "https://github.com/daeuniverse/dae";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ oluceps ];
    platforms = platforms.linux;
  };
}
