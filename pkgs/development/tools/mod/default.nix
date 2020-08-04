{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "mod";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "marwan-at-work";
    repo = "mod";
    rev = "v${version}";
    sha256 = "1n0pipbq4fjban8hsxhyl5w8xrl4ai1pvgd02i1j1awmm2l3ykzl";
  };

  vendorSha256 = "032s62rjjq7bqiz5fg17yfkq4j4dsbl6vhvs1wf2sg8jvbqmvdwn";

  subPackages = [ "cmd/mod" ];

  meta = with lib; {
    description = "Automated Semantic Import Versioning Upgrades for Go";
    longDescription = ''
      Command line tool to upgrade/downgrade Semantic Import Versioning in Go
      Modules.
      '';
    homepage = "https://github.com/marwan-at-work/mod";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
