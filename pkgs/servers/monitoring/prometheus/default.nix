{ stdenv, lib, go, buildGoPackage, fetchFromGitHub, mkYarnPackage, nixosTests }:

let
  version = "2.22.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prometheus";
    sha256 = "04pf3shdfd25wf8snkan5hzv1gjzazjw06i11xaamnc8gfahnzdv";
  };

  webui = mkYarnPackage {
    src = "${src}/web/ui/react-app";
    packageJSON = ./webui-package.json;
    yarnNix = ./webui-yarndeps.nix;

    # The standard yarn2nix directory management causes build failures with
    # Prometheus's webui due to using relative imports into node_modules. Use
    # an extremely simplified version of it instead.
    configurePhase = "ln -s $node_modules node_modules";
    buildPhase = "PUBLIC_URL=. yarn build";
    installPhase = "mv build $out";
    distPhase = "true";
  };
in buildGoPackage rec {
  pname = "prometheus";
  inherit src version;

  goPackagePath = "github.com/prometheus/prometheus";

  postPatch = ''
    ln -s ${webui.node_modules} web/ui/react-app/node_modules
    ln -s ${webui} web/ui/static/react
  '';

  buildFlagsArray = let
    t = "${goPackagePath}/vendor/github.com/prometheus/common/version";
  in [
    "-tags=builtinassets"
    ''
      -ldflags=
         -X ${t}.Version=${version}
         -X ${t}.Revision=unknown
         -X ${t}.Branch=unknown
         -X ${t}.BuildUser=nix@nixpkgs
         -X ${t}.BuildDate=unknown
         -X ${t}.GoVersion=${lib.getVersion go}
    ''
  ];

  preBuild = ''
    make -C go/src/${goPackagePath} assets
  '';

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
