{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ssmsh";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "bwhaley";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rvvawn4cavqhbrrp616mi5ipn4q6j22227h4rbjh0zxdlna23gm";
  };

  vendorSha256 = "127xni0i7w42075bspmm5r61j858i1p59jr2ib8f9r1pbizh63xw";

  doCheck = true;

  buildFlagsArray = [ "-ldflags=-w -s -X main.Version=${version}" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/bwhaley/ssmsh";
    description = "An interactive shell for AWS Parameter Store";
    license = licenses.mit;
    maintainers = with maintainers; [ dbirks ];
  };
}
