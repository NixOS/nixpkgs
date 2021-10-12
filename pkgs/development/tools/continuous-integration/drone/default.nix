{ lib, fetchFromGitHub, buildGoModule
, enableUnfree ? true }:

buildGoModule rec {
  pname = "drone.io${lib.optionalString (!enableUnfree) "-oss"}";
  version = "2.0.3";

  vendorSha256 = "sha256-3qTH/p0l6Ke1F9SUcvK2diqZooOMnlXYO1PHLdJJ8PM=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone";
    rev = "v${version}";
    sha256 = "sha256-MKV5kor+Wm9cuIFFcjSNyCgVKtY+/B9sgBOXMMRvMPI=";
  };

  tags = lib.optionals (!enableUnfree) [ "oss" "nolimit" ];

  meta = with lib; {
    maintainers = with maintainers; [ elohmeier vdemeester ];
    license = with licenses; if enableUnfree then unfreeRedistributable else asl20;
    description = "Continuous Integration platform built on container technology";
  };
}
