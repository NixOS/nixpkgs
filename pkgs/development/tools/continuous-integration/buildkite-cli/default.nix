{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "buildkite-cli";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-fidE4MSZS53Odv5tlNPFJEhcb8JTmILVRNmcVF9Z9Oc=";
  };

  vendorHash = "sha256-stxsMJPBUclLlmR88c7OwAhsw9dhyBIhStuxLVu00bo=";

  doCheck = false;

  postPatch = ''
    patchShebangs .buildkite/steps/{lint,run-local}.sh
  '';

  subPackages = [ "cmd/bk" ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "Command line interface for Buildkite";
    homepage = "https://github.com/buildkite/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ groodt ];
    mainProgram = "bk";
  };
}
