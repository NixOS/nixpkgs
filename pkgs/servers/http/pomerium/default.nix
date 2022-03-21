{ buildGoModule
, fetchFromGitHub
, lib
, envoy
, zip
, nixosTests
, pomerium-cli
}:

let
  inherit (lib) concatStringsSep concatMap id mapAttrsToList;
in
buildGoModule rec {
  pname = "pomerium";
  version = "0.17.0";
  src = fetchFromGitHub {
    owner = "pomerium";
    repo = "pomerium";
    rev = "v${version}";
    hash = "sha256:1hv76i6k9f0kp527nxlxqhklsvkh2cmfnqlszmlk2hxij31qnf8q";
  };

  vendorSha256 = "sha256:1cq4m5a7z64yg3v1c68d15ilw78il6p53vaqzxgn338zjggr3kig";
  subPackages = [
    "cmd/pomerium"
  ];

  ldflags = let
    # Set a variety of useful meta variables for stamping the build with.
    setVars = {
      "github.com/pomerium/pomerium/internal/version" = {
        Version = "v${version}";
        BuildMeta = "nixpkgs";
        ProjectName = "pomerium";
        ProjectURL = "github.com/pomerium/pomerium";
      };
      "github.com/pomerium/pomerium/internal/envoy" = {
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
    rm internal/envoy/files/files_{darwin,linux}*.go
    cat <<EOF >internal/envoy/files/files_generic.go
    package files

    import _ "embed" // embed

    var rawBinary []byte

    //go:embed envoy.sha256
    var rawChecksum string

    //go:embed envoy.version
    var rawVersion string
    EOF
    sha256sum '${envoy}/bin/envoy' > internal/envoy/files/envoy.sha256
    echo '${envoy.version}' > internal/envoy/files/envoy.version
  '';

  installPhase = ''
    install -Dm0755 $GOPATH/bin/pomerium $out/bin/pomerium
  '';

  passthru.tests = {
    inherit (nixosTests) pomerium;
    inherit pomerium-cli;
  };

  meta = with lib; {
    homepage = "https://pomerium.io";
    description = "Authenticating reverse proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = [ "x86_64-linux" ];  # Envoy derivation is x86_64-linux only.
  };
}
