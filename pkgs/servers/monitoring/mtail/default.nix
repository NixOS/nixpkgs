{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "mtail";
  version = "3.0.0-rc43";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mtail";
    rev = "v${version}";
    sha256 = "1lw7gz6fh3z7j4hin4q6y3wxxl4sgd4li1c0z60hmvfs671n6dg9";
  };

  vendorSha256 = "0zymch6xfnyzjzizrjljmscqf8m99580zxjwc2rb9hn0324shcwq";

  doCheck = false;

  subPackages = [ "cmd/mtail" ];

  preBuild = ''
    go generate -x ./internal/vm/
  '';

  buildFlagsArray = [
    "-ldflags=-X main.Version=${version}"
  ];

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://github.com/google/mtail";
    description = "Tool for extracting metrics from application logs";
  };
}
