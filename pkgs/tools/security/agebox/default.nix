{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "agebox";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "slok";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mg16xxvsbm5jxlkdjyi3nsvzj37858d9ksh1wsa9ycxj2qipgw2";
  };
  vendorSha256 = "1gw83bd14ig18y8si3f94iivx2ir1vw4b5b95fp6r7qhfp0rgbih";

  ldflags = [
    "-s" "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/slok/agebox";
    changelog = "https://github.com/slok/agebox/releases/tag/v${version}";
    description = "Age based repository file encryption gitops tool";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse ];
  };
}
