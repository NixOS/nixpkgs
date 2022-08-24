{ buildGoModule
, fetchFromGitHub
, callPackage
, lib
, envoy
, nixosTests
, pomerium-ui
, pomerium-cli
}:

let
  inherit (lib) concatStringsSep concatMap id mapAttrsToList;
  common = callPackage ./common.nix { };
in
buildGoModule rec {
  inherit (common) version src vendorSha256 meta;
  pname = "pomerium";

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

    # put the built UI files where they will be picked up as part of binary build
    cp -r ${pomerium-ui} ui
  '';

  installPhase = ''
    install -Dm0755 $GOPATH/bin/pomerium $out/bin/pomerium
  '';

  passthru.tests = {
    inherit (nixosTests) pomerium;
    inherit pomerium-cli;
  };
}
