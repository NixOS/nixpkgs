{ lib, buildGoModule, fetchFromGitHub, updateGolangSysHook }:

buildGoModule rec {
  pname = "awsweeper";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "jckuester";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5D/4Z8ADlA+4+2EINmP5OfX5exzhfbq2TydPRlJDA6Y=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-zgn+n/1N+JVqaKrtSc4T659LG+Yj5w/qTpouTzBl6xg=";

  ldflags = [ "-s" "-w" "-X github.com/jckuester/awsweeper/internal.version=${version}" "-X github.com/jckuester/awsweeper/internal.commit=${src.rev}" "-X github.com/jckuester/awsweeper/internal.date=unknown" ];

  doCheck = false;

  meta = with lib; {
    description = "A tool to clean out your AWS account";
    homepage = "https://github.com/jckuester/awsweeper";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
