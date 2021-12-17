{ stdenv
, lib
, go
, pkgs
, nodejs
, nodePackages
, buildGoModule
, fetchFromGitHub
, mkYarnPackage
, nixosTests
, fetchpatch
}:

let
  version = "2.30.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prometheus";
    sha256 = "1as6x5bsp7mxa4rp7jhyjlpcvzqm1zngnwvp73rc4rwhz8w8vm3k";
  };

  goPackagePath = "github.com/prometheus/prometheus";

  codemirrorNode = import ./webui/codemirror-promql {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
  webuiNode = import ./webui/webui {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  codemirror = stdenv.mkDerivation {
    name = "prometheus-webui-codemirror-promql";
    src = "${src}/web/ui/module/codemirror-promql";

    buildInputs = [ nodejs nodePackages.typescript codemirrorNode.nodeDependencies ];

    configurePhase = ''
      ln -s ${codemirrorNode.nodeDependencies}/lib/node_modules node_modules
    '';
    buildPhase = ''
      PUBLIC_URL=. npm run build
    '';
    installPhase = ''
      mkdir -p $out
      mv lib dist $out
    '';
    distPhase = ":";
  };


  webui = stdenv.mkDerivation {
    name = "prometheus-webui";
    src = "${src}/web/ui/react-app";

    buildInputs = [ nodejs webuiNode.nodeDependencies ];

    # create `node_modules/.cache` dir (we need writeable .cache)
    # and then copy the rest over.
    configurePhase = ''
      mkdir -p node_modules/{.cache,.bin}
      cp -a ${webuiNode.nodeDependencies}/lib/node_modules/. node_modules
    '';
    buildPhase = "PUBLIC_URL=. npm run build";
    installPhase = "mv build $out";
    distPhase = "true";
  };
in
buildGoModule rec {
  pname = "prometheus";
  inherit src version;

  vendorSha256 = "0qyv8vybx5wg8k8hwvrpp4hz9wv6g4kf9sq5v5qc2bxx6apc0s9r";

  excludedPackages = [ "documentation/prometheus-mixin" ];

  nativeBuildInputs = [ nodejs ];

  postPatch = ''
    # we don't want this anyways, as we
    # build modules for them
    echo "exit 0" > web/ui/module/build.sh

    ln -s ${webuiNode.nodeDependencies}/lib/node_modules web/ui/react-app/node_modules
    ln -s ${webui} web/ui/static/react

    # webui-codemirror
    ln -s ${codemirror}/dist web/ui/module/codemirror-promql/dist
    ln -s ${codemirror}/lib web/ui/module/codemirror-promql/lib
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

  # only run this in the real build, not during the vendor build
  # this should probably be fixed in buildGoModule
  preBuild = ''
    if [ -d vendor ]; then make assets; fi
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
