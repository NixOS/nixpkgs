{ buildGoModule
, fetchFromGitHub
, lib
, testers
, twitch-cli
}:

buildGoModule rec {
  pname = "twitch-cli";
  version = "1.1.20";

  src = fetchFromGitHub {
    owner = "twitchdev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hIyZwXDI3lJQOK27RaABf7cnj7jOxKdLUdZB5fp+7kY=";
  };

  patches = [
    ./application-name.patch
  ];

  vendorHash = "sha256-OhcRMXY8s+XciF+gV3cZ8fxtzo9+I76tBPZ0xG8ddHU=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.buildVersion=${version}"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.version = testers.testVersion {
    package = twitch-cli;
    command = "HOME=$(mktemp -d) ${pname} version";
    version = "${pname}/${version}";
  };

  meta = with lib; {
    description = "The official Twitch CLI to make developing on Twitch easier";
    homepage = "https://github.com/twitchdev/twitch-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ benediktbroich ];
  };
}
