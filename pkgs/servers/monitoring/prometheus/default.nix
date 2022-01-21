{ stdenv
, lib
, go
, buildGoModule
, fetchFromGitHub
, nodejs-16_x
, nixosTests
, fetchpatch
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
  version = "2.33.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prometheus";
    sha256 = "sha256-5QHJ8m9zBclPM7HyyNGOPGVYwiOfgyv/jK0gxjjYToA=";
  };

  goPackagePath = "github.com/prometheus/prometheus";

  # HACK: we can't use node2nix because it doesn't support
  # workspaces, so just shove everything into one big intermediate
  # derivation and call it a day.
  webuiDeps = stdenv.mkDerivation {
    pname = "prometheus-webui-deps";
    inherit version;

    src = "${src}/web/ui";

    nativeBuildInputs = [ nodejs-16_x ];

    buildPhase = "HOME=. npm install";
    installPhase = ''
      modulePaths=". react-app module/codemirror-promql"
      for path in $modulePaths; do
          mkdir -p $out/$path
          cp -r $path/node_modules $out/$path
      done
    '';
    dontFixup = true;

    outputHash = "sha256-sl+rqked1/C4QiTkaJ9/IpaboTOFQoM+DUb+vYUFM8E=";
    outputHashMode = "recursive";
  };

  webui = stdenv.mkDerivation {
    pname = "prometheus-webui";
    inherit src version;

    nativeBuildInputs = [ nodejs-16_x ];

    buildPhase = ''
      cd web/ui
      cp -r ${webuiDeps}/* .

      # HACK: rewrite all the script paths to run the correct Node binary
      modulePaths=". react-app module/codemirror-promql"
      for path in $modulePaths; do
        for script in $path/node_modules/.bin/*; do
          substituteInPlace $script --replace '/usr/bin/env node' '${nodejs-16_x}/bin/node'
        done
      done

      # HACK: create a directory that Node really wants to write to
      chmod +w react-app/node_modules
      mkdir react-app/node_modules/.cache

      bash -x build_ui.sh --all
    '';

    installPhase = "mv static/react $out";
  };
in
buildGoModule rec {
  pname = "prometheus";
  inherit src version;

  vendorSha256 = "sha256-zxQJze6FaJhmgvOBdFMIvEZaFAuhRtM+mtT5+JuvuOc=";

  excludedPackages = [ "documentation/prometheus-mixin" ];

  postPatch = ''
    ln -s ${webui} web/ui/static/react

    # Disable some service discovery to shrink binaries.
    ${lib.optionalString (!enableAWS)
      "sed -i -e '/register aws/d' discovery/install/install.go"}
    ${lib.optionalString (!enableAzure)
      "sed -i -e '/register azure/d' discovery/install/install.go"}
    ${lib.optionalString (!enableConsul)
      "sed -i -e '/register consul/d' discovery/install/install.go"}
    ${lib.optionalString (!enableDigitalOcean)
      "sed -i -e '/register digitalocean/d' discovery/install/install.go"}
    ${lib.optionalString (!enableEureka)
      "sed -i -e '/register eureka/d' discovery/install/install.go"}
    ${lib.optionalString (!enableGCE)
      "sed -i -e '/register gce/d' discovery/install/install.go"}
    ${lib.optionalString (!enableHetzner)
      "sed -i -e '/register hetzner/d' discovery/install/install.go"}
    ${lib.optionalString (!enableKubernetes)
      "sed -i -e '/register kubernetes/d' discovery/install/install.go"}
    ${lib.optionalString (!enableLinode)
      "sed -i -e '/register linode/d' discovery/install/install.go"}
    ${lib.optionalString (!enableMarathon)
      "sed -i -e '/register marathon/d' discovery/install/install.go"}
    ${lib.optionalString (!enableMoby)
      "sed -i -e '/register moby/d' discovery/install/install.go"}
    ${lib.optionalString (!enableOpenstack)
      "sed -i -e '/register openstack/d' discovery/install/install.go"}
    ${lib.optionalString (!enablePuppetDB)
      "sed -i -e '/register puppetdb/d' discovery/install/install.go"}
    ${lib.optionalString (!enableScaleway)
      "sed -i -e '/register scaleway/d' discovery/install/install.go"}
    ${lib.optionalString (!enableTriton)
      "sed -i -e '/register triton/d' discovery/install/install.go"}
    ${lib.optionalString (!enableUyuni)
      "sed -i -e '/register uyuni/d' discovery/install/install.go"}
    ${lib.optionalString (!enableXDS)
      "sed -i -e '/register xds/d' discovery/install/install.go"}
    ${lib.optionalString (!enableZookeeper)
      "sed -i -e '/register zookeeper/d' discovery/install/install.go"}
  '';

  tags = [ "builtinassets" ];

  ldflags =
    let
      t = "${goPackagePath}/vendor/github.com/prometheus/common/version";
    in
    [
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.GoVersion=${lib.getVersion go}"
    ];

  preBuild = ''
    # only run this in the real build, not during the vendor build
    # this should probably be fixed in buildGoModule
    if [ -d vendor ]; then
      # HACK!
      #
      # Tell make we've already built the UI,
      # because we did, just not in a way it expects
      make assets \
        -o ui-install \
        -o ui-build
    fi
  '';

  preInstall = ''
    mkdir -p "$out/share/doc/prometheus" "$out/etc/prometheus"
    cp -a $src/documentation/* $out/share/doc/prometheus
    cp -a $src/console_libraries $src/consoles $out/etc/prometheus
  '';

  # doCheck = !stdenv.isDarwin; # https://hydra.nixos.org/build/130673870/nixlog/1
  doCheck = false;

  passthru.tests = { inherit (nixosTests) prometheus; };

  meta = with lib; {
    description = "Service monitoring system and time series database";
    homepage = "https://prometheus.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz globin willibutz Frostman ];
    platforms = platforms.unix;
  };
}
