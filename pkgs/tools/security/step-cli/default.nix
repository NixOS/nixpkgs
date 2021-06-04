{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "step-cli";
  version = "0.15.16";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-/HqCG3LscwogLXvZlL2CVo2Pj1hVRnOMPCmG1hxrG/I=";
  };

  preCheck = ''
    # Tries to connect to smallstep.com
    rm command/certificate/remote_test.go
  '';
  vendorSha256 = "sha256-plQgIqs6QUbzndn8C0ByKceGtz/JxZ1Rx0fXWHNJ0kM=";

  meta = with lib; {
    description = "A zero trust swiss army knife for working with X509, OAuth, JWT, OATH OTP, etc";
    homepage = "https://smallstep.com/cli/";
    license = licenses.asl20;
    maintainers = with maintainers; [ xfix ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
