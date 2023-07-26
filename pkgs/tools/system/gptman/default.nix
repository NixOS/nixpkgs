{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, testers, gptman }:

rustPlatform.buildRustPackage rec {
  pname = "gptman";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "rust-disk-partition-management";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sDRnvF/XPXgWIIIrOmnEuktP8XvZxPahF2n4h8RCX+o=";
  };

  cargoHash = "sha256-voslPSh7n31cGTKaayKXomgiXWVTutuc4FxfnZUDejc=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  buildFeatures = [ "cli" ];

  passthru.tests.version = testers.testVersion {
    package = gptman;
  };

  meta = with lib; {
    description = "A GPT manager that allows you to copy partitions from one disk to another and more";
    homepage = "https://github.com/rust-disk-partition-management/gptman";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}
