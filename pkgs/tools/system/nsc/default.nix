{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nsc";
  version = "2.7.6";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aieUCQ5JVJQs4RoTGaXwfTv3xC1ozSsQyfCLsD245go=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
    "-X main.builtBy=nixpkgs"
  ];

  vendorHash = "sha256-gDwppx0ORG+pXzTdGtUVbiFyTD/P7avt+/V89Gl0QYY=";

  preCheck = ''
    # Tests attempt to write to the home directory.
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "A tool for creating NATS account and user access configurations";
    homepage = "https://github.com/nats-io/nsc";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ cbrewster ];
    mainProgram = "nsc";
    broken = stdenv.isDarwin;
  };
}
