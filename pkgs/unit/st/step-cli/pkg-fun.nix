{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "step-cli";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-fSVRDmgDbByAWVzvidrtqCQE+LzS1WpzOAt12ZiNBT4=";
  };

  ldflags = [
    "-w"
    "-s"
    "-X main.Version=${version}"
  ];

  preCheck = ''
    # Tries to connect to smallstep.com
    rm command/certificate/remote_test.go
  '';

  vendorHash = "sha256-oW1C0EEaNsT4ne1g4kyb+A8sbXgzCAJlhJHUmdH2r/0=";

  meta = with lib; {
    description = "A zero trust swiss army knife for working with X509, OAuth, JWT, OATH OTP, etc";
    homepage = "https://smallstep.com/cli/";
    changelog = "https://github.com/smallstep/cli/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ xfix ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "step";
  };
}
