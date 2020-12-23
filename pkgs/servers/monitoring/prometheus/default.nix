{ stdenv, lib, go, buildGoPackage, fetchFromGitHub, mkYarnPackage, nixosTests
, fetchpatch
}:

let
  version = "2.23.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prometheus";
    sha256 = "sha256-UQ1r8271EiZDU/h2zta6toMRfk2GjXol8GexYL9n+BE=";
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

  patches = [
    # Fix https://github.com/prometheus/prometheus/issues/8144
    (fetchpatch {
      url = "https://github.com/prometheus/prometheus/commit/8b64b70fe4a5aa2877c95aa12c6798b12d3ff7ec.patch";
      sha256 = "sha256-RuXT5pBXv8z6WoE59KNGh+OXr1KGLGWs/n0Hjf4BuH8=";
    })
  ];

  postPatch = ''
    ln -s ${webui.node_modules} web/ui/react-app/node_modules
    ln -s ${webui} web/ui/static/react
  '';

  buildFlags = "-tags=builtinassets";
  buildFlagsArray = let
    t = "${goPackagePath}/vendor/github.com/prometheus/common/version";
  in [
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
