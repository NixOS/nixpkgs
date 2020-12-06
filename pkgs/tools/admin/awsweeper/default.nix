{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "awsweeper";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "jckuester";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ln4s04n1qd1wv88ahhvvvphlxf6c9krqz9lmbcx3n67sb8xngm5";
  };

  vendorSha256 = "0zlhb84fmrnwq71d0h83p28aqlfclcydndl0z2j9nx2skjlxax2i";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/jckuester/awsweeper/internal.version=${version} -X github.com/jckuester/awsweeper/internal.commit=${src.rev} -X github.com/jckuester/awsweeper/internal.date=unknown" ];

  doCheck = false;

  meta = with lib; {
    description = "A tool to clean out your AWS account";
    homepage = "https://github.com/jckuester/awsweeper";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
