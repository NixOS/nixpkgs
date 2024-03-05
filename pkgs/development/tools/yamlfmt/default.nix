{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yamlfmt";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7+ui5jEJkjejAZRdM+okoF3Qw8SJSTKJS7LNNnBgz0g=";
  };

  vendorHash = "sha256-JiFVc2+LcCgvnEX6W4XBtIgXcILEO2HZT4DTp62eUJU=";

  doCheck = false;

  meta = with lib; {
    description = "An extensible command line tool or library to format yaml files.";
    homepage = "https://github.com/google/yamlfmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ sno2wman ];
    mainProgram = "yamlfmt";
  };
}
