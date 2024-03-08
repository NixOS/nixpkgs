{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "miller";
  version = "6.11.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${version}";
    sha256 = "sha256-MmQBj3ANiObyTsAW55Bh9p94Pu+ynySaxHjHjpBacno=";
  };

  outputs = [ "out" "man" ];

  vendorHash = "sha256-K9B++jinB8iRWb96Lha/gM8/3vPQNd4LoZggGXh7VD4=";

  postInstall = ''
    mkdir -p $man/share/man/man1
    mv ./man/mlr.1 $man/share/man/man1
  '';

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
