{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "step-cli";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-B0LGedExlk9XllWilZ0QAwQHNyISAI2WJ48P2STbxSY=";
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

  vendorHash = "sha256-A38pmKRulvmxXbIaUsTiMWgq1MhUKkvuGp07H1rxCJg=";

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
