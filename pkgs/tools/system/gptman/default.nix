{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, testers, gptman }:

rustPlatform.buildRustPackage rec {
  pname = "gptman";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "rust-disk-partition-management";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Qi2nrvF566AK+JsP7V9tVQXwAU63TNpfTFZLuM/h1Ps=";
  };

  cargoHash = "sha256-YMlwlSq14S37SqewglvxZYUL67fT66hh22t0N8h+2vk=";

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
    mainProgram = "gptman";
  };
}
