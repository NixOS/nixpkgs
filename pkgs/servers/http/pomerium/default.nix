{ buildGoModule
, fetchFromGitHub
, callPackage
, lib
, envoy
, mkYarnPackage
, fetchYarnDeps
, nixosTests
, pomerium-cli
}:

let
  inherit (lib) concatStringsSep concatMap id mapAttrsToList;
in
buildGoModule rec {
  pname = "pomerium";
  version = "0.24.0";
  src = fetchFromGitHub {
    owner = "pomerium";
    repo = "pomerium";
    rev = "v${version}";
    hash = "sha256-MVyLHrVWpLVkvypMOZ7LvQJTGvawqb0/8fd2GbqC9Wk=";
  };

  vendorHash = "sha256-j/6bssSkZu6KXtaNsYPJhqoepn3SDcoJwz4Dn6dYEME=";

  ui = mkYarnPackage {
    inherit version;
    src = "${src}/ui";

    packageJSON = ./package.json;
    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/ui/yarn.lock";
      sha256 = lib.fileContents ./yarn-hash;
    };

    buildPhase = ''
      runHook preBuild
      yarn --offline build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -R deps/pomerium/dist $out
      runHook postInstall
    '';

    doDist = false;
  };

  subPackages = [
    "cmd/pomerium"
  ];

  # patch pomerium to allow use of external envoy
  patches = [ ./external-envoy.diff ];

  ldflags = let
    # Set a variety of useful meta variables for stamping the build with.
    setVars = {
      "github.com/pomerium/pomerium/internal/version" = {
        Version = "v${version}";
        BuildMeta = "nixpkgs";
        ProjectName = "pomerium";
        ProjectURL = "github.com/pomerium/pomerium";
      };
      "github.com/pomerium/pomerium/pkg/envoy" = {
        OverrideEnvoyPath = "${envoy}/bin/envoy";
      };
    };
    concatStringsSpace = list: concatStringsSep " " list;
    mapAttrsToFlatList = fn: list: concatMap id (mapAttrsToList fn list);
    varFlags = concatStringsSpace (
      mapAttrsToFlatList (package: packageVars:
        mapAttrsToList (variable: value:
          "-X ${package}.${variable}=${value}"
        ) packageVars
      ) setVars);
  in [
    "${varFlags}"
  ];

  preBuild = ''
    # Replace embedded envoy with nothing.
    # We set OverrideEnvoyPath above, so rawBinary should never get looked at
    # but we still need to set a checksum/version.
    rm pkg/envoy/files/files_{darwin,linux}*.go
    cat <<EOF >pkg/envoy/files/files_external.go
    package files

    import _ "embed" // embed

    var rawBinary []byte

    //go:embed envoy.sha256
    var rawChecksum string

    //go:embed envoy.version
    var rawVersion string
    EOF
    sha256sum '${envoy}/bin/envoy' > pkg/envoy/files/envoy.sha256
    echo '${envoy.version}' > pkg/envoy/files/envoy.version

    # put the built UI files where they will be picked up as part of binary build
    cp -r ${ui}/* ui/dist
  '';

  installPhase = ''
    install -Dm0755 $GOPATH/bin/pomerium $out/bin/pomerium
  '';

  passthru = {
    tests = {
      inherit (nixosTests) pomerium;
      inherit pomerium-cli;
    };
    updateScript = ./updater.sh;
  };

  meta = with lib; {
    homepage = "https://pomerium.io";
    description = "Authenticating reverse proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
