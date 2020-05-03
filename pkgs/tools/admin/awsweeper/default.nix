{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "awsweeper";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "cloudetc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ybrrpnp6rh7rcwihww43cvhfhzzyy51rdk1hwy9ljpkg37k4y28";
  };

  modSha256 = "07zz6wf9cq3wylihi9fx0rd85iybnq5z5c9gqw1lhpvqcrad4491";

  meta = with lib; {
    description = "A tool to clean out your AWS account";
    homepage = "https://github.com/cloudetc/awsweeper/";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
