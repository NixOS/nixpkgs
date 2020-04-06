{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "certigo";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "square";
    repo = pname;
    rev = "v${version}";
    sha256 = "0siwbxxzknmbsjy23d0lvh591ngabqhr2g8mip0siwa7c1y7ivv4";
  };

  modSha256 = "1i5n5yh6nvv2i2nm60vqy1gngj8p5w6ma5fcwmp7bl4jxjrzbi83";

  meta = with stdenv.lib; {
    description = "A utility to examine and validate certificates in a variety of formats";
    homepage = "https://github.com/square/certigo";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
