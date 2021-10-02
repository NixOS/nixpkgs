{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "evans";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "ktr0731";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ftt3lnwLk2Zx1DxDmZx2hBqXcxzqUb6I/gEdQJuFsCc=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-WclmINHcgRtbRSZGv+lOgwuImHKVC9cfK8C+f9JBcts=";

  meta = with lib; {
    description = "More expressive universal gRPC client";
    homepage = "https://evans.syfm.me/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ diogox ];
  };
}
