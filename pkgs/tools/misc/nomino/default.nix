{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "nomino";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "yaa110";
    repo = pname;
    rev = version;
    sha256 = "sha256-+bnEuSro3/t9aXu2WpwsaqHqB+poSXsVbna01a7pnKo=";
  };

  cargoSha256 = "sha256-IKsA8btCmKnZfRIwS4QdxJMi1As6SNbTI7ibOL7M+5U=";

  meta = with lib; {
    description = "Batch rename utility for developers";
    homepage = "https://github.com/yaa110/nomino";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
