{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "certstrap";
  version = "1.2.0";

  goPackagePath = "github.com/square/certstrap";

  src = fetchFromGitHub {
    owner = "square";
    repo = "certstrap";
    rev = "v${version}";
    sha256 = "1ymchnn7c9g3pq7rw4lrwsd6z3wfjx90g7qgrw6r5hssl77mnscj";
  };

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Tools to bootstrap CAs, certificate requests, and signed certificates";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ volth ];
  };
}
