{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "step-cli";
  version = "0.25.2";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-umo0f4cXxnxg3xH1aHeJE2brUT9w+Gp+0Qzq4zIQ8oI=";
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

  vendorHash = "sha256-R9UJHXs35/yvwlqu1iR3lJN/w8DWMqw48Kc+7JKfD7I=";

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
