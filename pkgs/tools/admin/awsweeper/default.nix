{ lib, buildGoModule, fetchFromGitHub, awsweeper, testVersion }:

buildGoModule rec {
  pname = "awsweeper";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "jckuester";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fpWoLFSwSVxaiWyVMSmQTd3o/zOySUXNM2YhxMQ7nsA=";
  };

  vendorSha256 = "sha256-1u1mzANLlWduAQF1GUX7BJSyYlSZwNQISqKwbyRlGog=";

  ldflags = [ "-s" "-w" "-X github.com/jckuester/awsweeper/internal.version=${version}" "-X github.com/jckuester/awsweeper/internal.commit=${src.rev}" "-X github.com/jckuester/awsweeper/internal.date=unknown" ];

  doCheck = false;

  passthru.tests.version = testVersion { package = awsweeper; };

  meta = with lib; {
    description = "A tool to clean out your AWS account";
    homepage = "https://github.com/jckuester/awsweeper";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
