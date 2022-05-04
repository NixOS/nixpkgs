{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "proto-contrib";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "emicklei";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ksxic7cypv9gg8q5lkl5bla1n9i65z7b03cx9lwq6252glmf2jk";
  };

  vendorSha256 = "093blawprs2yf478zp9p1zc7mmimgpiwrw6nh8nqml89y5b5zldc";

  doCheck = false;

  meta = with lib; {
    description = "Contributed tools and other packages on top of the Go proto package";
    homepage = "https://github.com/emicklei/proto-contrib";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
