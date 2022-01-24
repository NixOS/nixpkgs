{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "duf";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    rev = "v${version}";
    sha256 = "sha256-Usdu7f3XPTIT39H23vfP0XBlvNPgPA+3BMyOzFOyLHQ=";
  };

  vendorSha256 = "sha256-6PV/v+rk63FIR2M0Q7EzqjVvWIwHtK6TQpEYxkXLQ50=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/muesli/duf/";
    description = "Disk Usage/Free Utility";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ petabyteboy penguwin SuperSandro2000 ];
  };
}
