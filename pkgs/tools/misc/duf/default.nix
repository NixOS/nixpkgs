{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "duf";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    rev = "v${version}";
    sha256 = "sha256-aRXm31sGHvHPpqPck5+jplbWT52OzaiQIgU/C7llJs8=";
  };

  vendorSha256 = "153z0ccd556c0wpnxgyjq7m0c4y2z6fxsqq2p77kly9nr8cpzdb9";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/muesli/duf/";
    description = "Disk Usage/Free Utility";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ petabyteboy penguwin SuperSandro2000 ];
  };
}
