{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "step-cli";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-gMXvHPqWvaZmzWiWrxlknaMkUraS64yrKl+RzAF7c4I=";
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

  vendorSha256 = "sha256-WF2UD0LwzCMkoW1EfcjV+9ZboPp1oWhmsSEryj13Kg0=";

  meta = with lib; {
    description = "A zero trust swiss army knife for working with X509, OAuth, JWT, OATH OTP, etc";
    homepage = "https://smallstep.com/cli/";
    license = licenses.asl20;
    maintainers = with maintainers; [ xfix ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
