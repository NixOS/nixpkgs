{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "certstrap";
  version = "1.1.1";

  goPackagePath = "github.com/square/certstrap";

  src = fetchFromGitHub {
    owner = "square";
    repo = "certstrap";
    rev = "v${version}";
    sha256 = "0j7gi2nzykny7i0gjax9vixw72l9jcm4wnwxgm72hh1pji0ysa8n";
  };

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Tools to bootstrap CAs, certificate requests, and signed certificates";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ volth ];
  };
}
