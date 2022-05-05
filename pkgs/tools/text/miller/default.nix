{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "miller";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    # NOTE: The tag v6.2.0 has still old version number, as reported by
    #       `mlr --version`. This is the current head of the 6.2.0 branch, with
    #       the correct version number.
    #
    #       For future releases please check if we can use
    #       `rev = "v${version}"` again.
    rev = "a6dc231eefc209eb66b50b0773542c2e63501bba";
    sha256 = "sha256-hMWcf43o1wiVjHsgH+ZDBny5vlZQkKyoJN5np4gUy4w=";
  };

  vendorSha256 = "sha256-2tl/twzkvWB1lnvi3fIptM77zi0lmAn7Pzoe0/lW6o4=";

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
