{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "the_platinum_searcher";
  version = "2.1.5";
  rev = "v${version}";

  goPackagePath = "github.com/monochromegane/the_platinum_searcher";

  src = fetchFromGitHub {
    inherit rev;
    owner = "monochromegane";
    repo = "the_platinum_searcher";
    sha256 = "1y7kl3954dimx9hp2bf1vjg1h52hj1v6cm4f5nhrqzwrawp0b6q0";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    homepage = "https://github.com/monochromegane/the_platinum_searcher";
    description = "A code search tool similar to ack and the_silver_searcher(ag)";
    license = licenses.mit;
  };
}
