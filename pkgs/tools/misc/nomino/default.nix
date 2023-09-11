{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nomino";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "yaa110";
    repo = pname;
    rev = version;
    hash = "sha256-pzAL7e72sO94qLEwsH/5RuiuzvnsSelIq47jdU8INDw=";
  };

  cargoHash = "sha256-gDOZ3nD7pTIRNXG3S+qTkl+HInBcAErvwPqa0NZWxY4=";

  meta = with lib; {
    description = "Batch rename utility for developers";
    homepage = "https://github.com/yaa110/nomino";
    changelog = "https://github.com/yaa110/nomino/releases/tag/${src.rev}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
