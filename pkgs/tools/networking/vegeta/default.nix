{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "vegeta";
  version = "12.10.0";
  rev = "e04d9c0df8177e8633bff4afe7b39c2f3a9e7dea";

  src = fetchFromGitHub {
    owner = "tsenart";
    repo = "vegeta";
    rev = "v${version}";
    sha256 = "sha256-lBJXMI/OVxgi4AqAFKE6cXLBagUZzUTRzvcJBr0Wh/c=";
  };

  vendorHash = "sha256-QWI2T1yJBATgCyGlR2dPbnBLn9KHQgfc30mPdMKzGsQ=";

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
