{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "awsweeper";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "cloudetc";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sbd1jgzz3rxxwgbni885zvvcznfc51imaxwv7f064290iqlbrv4";
  };

  modSha256 = "14yvf0svh7xqpc2y7xr94pc6r7d3iv2nsr8qs3f5q29hdc5hv3fs";

  meta = with lib; {
    description = "A tool to clean out your AWS account";
    homepage = "https://github.com/cloudetc/awsweeper/";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
