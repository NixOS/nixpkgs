{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "miller";
  version = "6.8.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${version}";
    sha256 = "sha256-AgKkB/c7rSgk2jS017vjaLPKdiWJ5y/1K5RM6c9RWQg=";
  };

  vendorHash = "sha256-4/BB4RaCXEgtGpBJGtccEAz9diogWTA4BxVLkOOlNMw=";

  subPackages = [ "cmd/mlr" ];

  meta = with lib; {
    description = "Like awk, sed, cut, join, and sort for data formats such as CSV, TSV, JSON, JSON Lines, and positionally-indexed";
    homepage    = "https://github.com/johnkerl/miller";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ mstarzyk ];
    mainProgram = "mlr";
    platforms   = platforms.all;
  };
}
