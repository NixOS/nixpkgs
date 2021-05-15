{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "fission";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "fission";
    repo = "fission";
    rev = version;
    sha256 = "0izvkjd7ydcxhr6zmgrbfm3ybz2kf4p27099lr07gd4x7c6xxmqr";
  };

  vendorSha256 = "12clw0wy4lypf45imqnabj39yxqpi348csr4m5d0d1rksxgvwngq";

  buildFlagsArray = "-ldflags=-s -w -X info.Version=${version}";

  subPackages = [ "cmd/fission-cli" ];

  postInstall = ''
    ln -s $out/bin/fission-cli $out/bin/fission
  '';

  meta = with lib; {
    description = "The cli used by end user to interact Fission";
    homepage = "https://fission.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ neverbehave ];
  };
}
