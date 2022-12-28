{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "miller";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${version}";
    sha256 = "sha256-k/ibxJYgk3CT+/mYJ3DN9GatuiIgMPMs1+5cbCg4jxM=";
  };

  vendorSha256 = "sha256-UQHqDuQeXfmGrRYSbqW6lnBDVTgDJGhJWmH4kgPrggE=";

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
