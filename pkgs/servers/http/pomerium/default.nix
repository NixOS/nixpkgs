{ buildGoModule
, fetchFromGitHub
, lib
, envoy
, zip
, nixosTests
}:

let
  inherit (lib) concatStringsSep mapAttrsToList;
in
buildGoModule rec {
  pname = "pomerium";
  version = "0.14.4";
  src = fetchFromGitHub {
    owner = "pomerium";
    repo = "pomerium";
    rev = "v${version}";
    hash = "sha256:097csr8f43cn0iq030ajvvpwnwcfmjxyyk6pcisdy937axlrzska";
  };

  vendorSha256 = "sha256:0n45xvwjiqyh41dsm4z1rnkgkycf5wfmacm804hqnd5rz7xk2shf";
  subPackages = [
    "cmd/pomerium"
    "cmd/pomerium-cli"
  ];

  buildFlagsArray = let
    # Set a variety of useful meta variables for stamping the build with.
    setVars = {
      Version = "v${version}";
      BuildMeta = "nixpkgs";
      ProjectName = "pomerium";
      ProjectURL = "github.com/pomerium/pomerium";
    };
    varFlags = concatStringsSep " " (mapAttrsToList (name: value: "-X github.com/pomerium/pomerium/internal/version.${name}=${value}") setVars);
  in [
    "-ldflags=${varFlags}"
  ];

  nativeBuildInputs = [
    zip
  ];

  # Pomerium expects to have envoy append to it in a zip.
  # We use a store-only (-0) zip, so that the Nix scanner can find any store references we had in the envoy binary.
  postBuild = ''
    # Append Envoy
    pushd $NIX_BUILD_TOP
    mkdir -p envoy
    cd envoy
    cp ${envoy}/bin/envoy envoy
    zip -0 envoy.zip envoy
    popd

    mv $GOPATH/bin/pomerium $GOPATH/bin/pomerium.old
    cat $GOPATH/bin/pomerium.old $NIX_BUILD_TOP/envoy/envoy.zip >$GOPATH/bin/pomerium
    zip --adjust-sfx $GOPATH/bin/pomerium
  '';

  # We also need to set dontStrip to avoid having the envoy ZIP stripped off the end.
  dontStrip = true;

  installPhase = ''
    install -Dm0755 $GOPATH/bin/pomerium $out/bin/pomerium
    install -Dm0755 $GOPATH/bin/pomerium-cli $out/bin/pomerium-cli
  '';

  passthru.tests = {
    inherit (nixosTests) pomerium;
  };

  meta = with lib; {
    homepage = "https://pomerium.io";
    description = "Authenticating reverse proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = [ "x86_64-linux" ];  # Envoy derivation is x86_64-linux only.
  };
}
