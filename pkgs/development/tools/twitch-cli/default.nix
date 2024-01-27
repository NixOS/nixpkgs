{ buildGoModule
, fetchFromGitHub
, lib
, testers
, twitch-cli
}:

buildGoModule rec {
  pname = "twitch-cli";
  version = "1.1.22";

  src = fetchFromGitHub {
    owner = "twitchdev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9tbU9gR8UHg98UKZ9ganapAz1bar18xb7ISvKoeuwe4=";
  };

  patches = [
    ./application-name.patch
  ];

  vendorHash = "sha256-1uUokMeI0D/apDFJLq+Go5BQp1JMYxJQF8nKvw52E7o=";

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
