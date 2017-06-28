{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "certstrap-${version}";
  version = "1.0.1";

  goPackagePath = "github.com/square/certstrap";

  src = fetchFromGitHub {
    owner = "square";
    repo = "certstrap";
    rev = "v${version}";
    sha256 = "0pw1g6nyb212ayic42rkm6i0cf4n2003f02qym6zp130m6aysb47";
  };

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Tools to bootstrap CAs, certificate requests, and signed certificates";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ volth ];
  };
}
