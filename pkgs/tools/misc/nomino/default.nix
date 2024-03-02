{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nomino";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "yaa110";
    repo = pname;
    rev = version;
    hash = "sha256-XT8+mwfDFsBVEcpttus1KeIS+4sKqJMJTwqYI3LfW5k=";
  };

  cargoHash = "sha256-KpjGwqjVORyxXJbMi2Ok7s6gRmM/aJRTsPtu/0PgGr8=";

  meta = with lib; {
    description = "Batch rename utility for developers";
    homepage = "https://github.com/yaa110/nomino";
    changelog = "https://github.com/yaa110/nomino/releases/tag/${src.rev}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "nomino";
  };
}
