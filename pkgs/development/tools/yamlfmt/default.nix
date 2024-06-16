{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yamlfmt";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VAXDkD4JLoiTomCNtuex/ZEAZtWDEEg5cxETYemvQW8=";
  };

  vendorHash = "sha256-UfULQw7wAEJjTFp6+ACF5Ki04eFKeUEgmbt1c8pUolA=";

  doCheck = false;

  meta = with lib; {
    description = "An extensible command line tool or library to format yaml files";
    homepage = "https://github.com/google/yamlfmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ sno2wman ];
    mainProgram = "yamlfmt";
  };
}
