{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "miller";
  version = "6.9.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${version}";
    sha256 = "sha256-g2Jnqo3U9acyqohGpcEEogq871qJQTc7k0/oIawAQW8=";
  };

  outputs = [ "out" "man" ];

  vendorHash = "sha256-/1/FTQL3Ki8QzL+1J4Ah8kwiJyGPd024di/1MC8gtkE=";

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
