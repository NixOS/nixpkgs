{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "step-cli";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-Ki6MrLVJf2U4Q0y6jtOQZOti/m3SULWNKZ9SdirlOVA=";
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

  vendorSha256 = "sha256-ftBZQmtrnGFMZRXDKmMyqnfxuY5vtrZDXVR43yd1shk=";

  meta = with lib; {
    description = "A zero trust swiss army knife for working with X509, OAuth, JWT, OATH OTP, etc";
    homepage = "https://smallstep.com/cli/";
    license = licenses.asl20;
    maintainers = with maintainers; [ xfix ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "step";
  };
}
