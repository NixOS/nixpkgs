{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "vegeta";
  version = "12.8.4";
  rev = "e04d9c0df8177e8633bff4afe7b39c2f3a9e7dea";

  src = fetchFromGitHub {
    owner = "tsenart";
    repo = "vegeta";
    rev = "v${version}";
    sha256 = "sha256-FAb7nf6jZju95YEZR1GjPnfbsA5M8NcIKQyc8cgEgWs=";
  };

  vendorSha256 = "sha256-v9Hu9eQJSmm4Glt49F7EN40rKjrg4acyll9Bfgey+Mw=";

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
