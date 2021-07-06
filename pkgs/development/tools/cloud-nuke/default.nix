{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rxWTh+iltD1kcntlu9sovwG/mQPmukYbw8V2FAFi1KE=";
  };

  vendorSha256 = "sha256-mfNbcnJ62v6tdEhOtA0P9lDoD5HmLBAtNcrv1H3/mSE=";

  buildFlagsArray = [ "-ldflags=-s -w -X main.VERSION=${version}" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
