{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "buildkite-cli";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-4MUgyUKyycsreAMVtyKJFpQOHvI6JJSn7TUZtbQANyc=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-3x7yJenJ2BHdqVPaBaqfFVeOSJZ/VRNF/TTfSsw+2os=";
=======
  vendorSha256 = "sha256-3x7yJenJ2BHdqVPaBaqfFVeOSJZ/VRNF/TTfSsw+2os=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  postPatch = ''
    patchShebangs .buildkite/steps/{lint,run-local}.sh
  '';

  subPackages = [ "cmd/bk" ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A command line interface for Buildkite";
    homepage = "https://github.com/buildkite/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ groodt ];
    mainProgram = "bk";
  };
}
