{ stdenv
, lib
, go
, pkgs
, buildGoModule
, fetchFromGitHub
, fetchurl
, nixosTests
, enableAWS ? true
, enableAzure ? true
, enableConsul ? true
, enableDigitalOcean ? true
, enableEureka ? true
, enableGCE ? true
, enableHetzner ? true
, enableKubernetes ? true
, enableLinode ? true
, enableMarathon ? true
, enableMoby ? true
, enableOpenstack ? true
, enablePuppetDB ? true
, enableScaleway ? true
, enableTriton ? true
, enableUyuni ? true
, enableXDS ? true
, enableZookeeper ? true
}:

let
  version = "2.35.0";
  webUiStatic = fetchurl {
    url = "https://github.com/prometheus/prometheus/releases/download/v${version}/prometheus-web-ui-${version}.tar.gz";
    sha256 = "sha256-66zWOjFTYwmspiKeklt3NAAT1uJJrZqeyQvWWsCN9fQ=";
  };
in
buildGoModule rec {
  pname = "prometheus";
  inherit version;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prometheus";
    sha256 = "sha256-h0uBs3xMKpRH3A1VG5xrhjXVAT7GL5L3UZWb3HJ2Fz4=";
  };

  vendorSha256 = "sha256-0I6hmjhdfB41rWOQ9FM9CMq5w5437ka/jLuFXcBQBlM=";

  excludedPackages = [ "documentation/prometheus-mixin" ];

  postPatch = ''
    tar -C web/ui -xzf ${webUiStatic}

    patchShebangs scripts

    # Enable only select service discovery to shrink binaries.
    (
      true  # prevent bash syntax error when all plugins are disabled
    ${lib.optionalString (enableAWS)
      "echo - github.com/prometheus/prometheus/discovery/aws"}
    ${lib.optionalString (enableAzure)
      "echo - github.com/prometheus/prometheus/discovery/azure"}
    ${lib.optionalString (enableConsul)
      "echo - github.com/prometheus/prometheus/discovery/consul"}
    ${lib.optionalString (enableDigitalOcean)
      "echo - github.com/prometheus/prometheus/discovery/digitalocean"}
    ${lib.optionalString (enableEureka)
      "echo - github.com/prometheus/prometheus/discovery/eureka"}
    ${lib.optionalString (enableGCE)
      "echo - github.com/prometheus/prometheus/discovery/gce"}
    ${lib.optionalString (enableHetzner)
      "echo - github.com/prometheus/prometheus/discovery/hetzner"}
    ${lib.optionalString (enableKubernetes)
      "echo - github.com/prometheus/prometheus/discovery/kubernetes"}
    ${lib.optionalString (enableLinode)
      "echo - github.com/prometheus/prometheus/discovery/linode"}
    ${lib.optionalString (enableMarathon)
      "echo - github.com/prometheus/prometheus/discovery/marathon"}
    ${lib.optionalString (enableMoby)
      "echo - github.com/prometheus/prometheus/discovery/moby"}
    ${lib.optionalString (enableOpenstack)
      "echo - github.com/prometheus/prometheus/discovery/openstack"}
    ${lib.optionalString (enablePuppetDB)
      "echo - github.com/prometheus/prometheus/discovery/puppetdb"}
    ${lib.optionalString (enableScaleway)
      "echo - github.com/prometheus/prometheus/discovery/scaleway"}
    ${lib.optionalString (enableTriton)
      "echo - github.com/prometheus/prometheus/discovery/triton"}
    ${lib.optionalString (enableUyuni)
      "echo - github.com/prometheus/prometheus/discovery/uyuni"}
    ${lib.optionalString (enableXDS)
      "echo - github.com/prometheus/prometheus/discovery/xds"}
    ${lib.optionalString (enableZookeeper)
      "echo - github.com/prometheus/prometheus/discovery/zookeeper"}
    ) > plugins.yml
  '';

  preBuild = ''
    if [[ -d vendor ]]; then make -o assets assets-compress plugins; fi
  '';

  tags = [ "builtinassets" ];

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.GoVersion=${lib.getVersion go}"
    ];

  preInstall = ''
    mkdir -p "$out/share/doc/prometheus" "$out/etc/prometheus"
    cp -a $src/documentation/* $out/share/doc/prometheus
    cp -a $src/console_libraries $src/consoles $out/etc/prometheus
  '';

  doCheck = !stdenv.isDarwin; # https://hydra.nixos.org/build/130673870/nixlog/1

  passthru.tests = { inherit (nixosTests) prometheus; };

  meta = with lib; {
    description = "Service monitoring system and time series database";
    homepage = "https://prometheus.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz globin willibutz Frostman ];
    platforms = platforms.unix;
  };
}
