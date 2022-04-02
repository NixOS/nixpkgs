{ buildGoModule
, fetchFromGitHub
, lib
, pomerium
}:

let
  inherit (lib) concatStringsSep concatMap id mapAttrsToList;
in
buildGoModule rec {
  pname = "pomerium-cli";
  version = pomerium.version;
  src = fetchFromGitHub {
    owner = "pomerium";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256:0230b22xjnpykj8bcdahzzlsvlrd63z2cmg6yb246c5ngjs835q1";
  };

  vendorSha256 = "sha256:0xx22lmh6wip1d1bjrp4lgab3q9yilw54v4lg24lf3xhbsr5si9b";
  subPackages = [
    "cmd/pomerium-cli"
  ];

  ldflags = let
    # Set a variety of useful meta variables for stamping the build with.
    setVars = {
      "github.com/pomerium/cli/version" = {
        Version = "v${version}";
        BuildMeta = "nixpkgs";
        ProjectName = "pomerium-cli";
        ProjectURL = "github.com/pomerium/cli";
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

  installPhase = ''
    install -Dm0755 $GOPATH/bin/pomerium-cli $out/bin/pomerium-cli
  '';

  meta = with lib; {
    homepage = "https://pomerium.io";
    description = "Client-side helper for Pomerium authenticating reverse proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
