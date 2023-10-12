{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "vegeta";
  version = "12.11.1";
  rev = "6fbe391628eeeae1adf39522a55078797e6e7f2e";

  src = fetchFromGitHub {
    owner = "tsenart";
    repo = "vegeta";
    rev = "v${version}";
    sha256 = "sha256-09DowdlbCsBQsAuAqC2QyUYvZHz7QmttO8Q6KHQCqLo=";
  };

  vendorHash = "sha256-5MvcZLg+NDDsqlpVV2FhTiEhXUJHq7eaP7Pba3iIipo=";

  subPackages = [ "." ];

  ldflags = (lib.mapAttrsToList (n: v: "-X main.${n}=${v}") {
    Version = version;
    Commit = rev;
    Date = "1970-01-01T00:00:00Z";
  }) ++ [ "-s" "-w" "-extldflags '-static'" ];

  meta = with lib; {
    description = "Versatile HTTP load testing tool";
    longDescription = ''
      Vegeta is a versatile HTTP load testing tool built out of a need to drill
      HTTP services with a constant request rate. It can be used both as a
      command line utility and a library.
    '';
    homepage = "https://github.com/tsenart/vegeta/";
    changelog = "https://github.com/tsenart/vegeta/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
}
