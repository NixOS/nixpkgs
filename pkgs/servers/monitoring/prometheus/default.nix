{ stdenv
, lib
, go
, buildGoModule
, fetchFromGitHub
, mkYarnPackage
, nixosTests
, fetchpatch
}:

let
  version = "2.27.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prometheus";
    sha256 = "0836ygyvld5skjycd7366i6vyf451s6cay5ng6c2fwq0skvp2gj2";
  };

  goPackagePath = "github.com/prometheus/prometheus";

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
in
buildGoModule rec {
  pname = "prometheus";
  inherit src version;

  vendorSha256 = "0dq3p7hga7m1aq78har5rr136hlb0kp8zhh2wzqlkxrk1f33w54p";

  excludedPackages = [ "documentation/prometheus-mixin" ];

  postPatch = ''
    ln -s ${webui.node_modules} web/ui/react-app/node_modules
    ln -s ${webui} web/ui/static/react
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
