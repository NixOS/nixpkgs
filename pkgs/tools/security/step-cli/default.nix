{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "step-cli";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-ZH3OrJGh7TekODW5rh8JShNHKfuxPr5HhVD7wsvi8M0=";
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

  vendorSha256 = "sha256-hJEL6kUc6aXKq7X23dRWhAni5oRDJ3CuNTx6JL049gA=";

  meta = with lib; {
    description = "A zero trust swiss army knife for working with X509, OAuth, JWT, OATH OTP, etc";
    homepage = "https://smallstep.com/cli/";
    license = licenses.asl20;
    maintainers = with maintainers; [ xfix ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "step";
  };
}
