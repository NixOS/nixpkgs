{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "corerad";
  version = "0.1.4";

  goPackagePath = "github.com/mdlayher/corerad";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "corerad";
    rev = "v${version}";
    sha256 = "0qlmmgdz69gqqn6h5kb3gsjyj7lm6pcfcx9xlmrxhisj914ij76r";
  };

  modSha256 = "0vim91yvw0cf9bd10hfanz8azq7q19lp2x61rs44ycx9zm3qdhcw";

  meta = with stdenv.lib; {
    homepage = "https://github.com/mdlayher/corerad";
    description = "CoreRAD extensible and observable IPv6 NDP RA daemon";
    license = licenses.asl20;
    maintainers = with maintainers; [ mdlayher ];
  };
}
