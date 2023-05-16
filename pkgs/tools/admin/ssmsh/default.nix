<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, testers, ssmsh }:

buildGoModule rec {
  pname = "ssmsh";
  version = "1.4.8";
=======
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ssmsh";
  version = "1.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bwhaley";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-GpN+yicgFIHOaMeJJcRn55f6fQbFX12vSV089/cMsqc=";
  };

  vendorHash = "sha256-17fmdsfOrOaySPsXofLzz0+vmiemg9MbnWhRoZ67EuQ=";
=======
    sha256 = "sha256-juyTCtcuFIlKyLxDrK5tRRzCMwoSXG4EUA32E/Z4y5c=";
  };

  vendorSha256 = "sha256-dqUMwnHRsR8n4bHEKoePyuqr8sE4NWPpuYo5SwOw0Rw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = true;

  ldflags = [ "-w" "-s" "-X main.Version=${version}" ];

<<<<<<< HEAD
  passthru.tests = testers.testVersion {
    package = ssmsh;
    command = "ssmsh -version";
    version = "Version ${version}";
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://github.com/bwhaley/ssmsh";
    description = "An interactive shell for AWS Parameter Store";
    license = licenses.mit;
    maintainers = with maintainers; [ dbirks ];
  };
}
