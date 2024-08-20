{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, testers, gptman }:

rustPlatform.buildRustPackage rec {
  pname = "gptman";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "rust-disk-partition-management";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ebV61EilGggix6JSN/MW4Ka0itkSpvikLDSO005TTYY=";
  };

  cargoHash = "sha256-P+qez0oVsHBiaBYban2o8MRvF8ElLf5zb+p+tYunWWA=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  buildFeatures = [ "cli" ];

  passthru.tests.version = testers.testVersion {
    package = gptman;
  };

  meta = with lib; {
    description = "GPT manager that allows you to copy partitions from one disk to another and more";
    homepage = "https://github.com/rust-disk-partition-management/gptman";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
    mainProgram = "gptman";
  };
}
