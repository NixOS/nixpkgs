{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "trickster";
  version = "1.1.5";
  rev = "4595bd6a1ae1165ef497251ad85c646dadc8a925";

  src = fetchFromGitHub {
    owner = "trickstercache";
    repo = "trickster";
    rev = "v${version}";
    sha256 = "sha256-BRD8IF3s9RaDorVtXRvbKLVVVXWiEQTQyKBR9jFo1eM=";
  };

  vendorHash = null;

  subPackages = [ "cmd/trickster" ];

  preBuild =
    let
      ldflags = with lib;
        concatStringsSep " " (
          [ "-extldflags '-static'" "-s" "-w" ] ++
          (mapAttrsToList (n: v: "-X main.application${n}=${v}") {
            BuildTime = "1970-01-01T00:00:00+0000";
            GitCommitID = rev;
            GoVersion = "$(go env GOVERSION)";
            GoArch = "$(go env GOARCH)";
          })
        );
    in
    ''
      buildFlagsArray+=("-ldflags=${ldflags}")
    '';

  # Tests are broken.
  doCheck = false;

  meta = with lib; {
    description = "Reverse proxy cache and time series dashboard accelerator";
    longDescription = ''
      Trickster is a fully-featured HTTP Reverse Proxy Cache for HTTP
      applications like static file servers and web APIs.
    '';
    homepage = "https://trickstercache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.linux;
  };
}
