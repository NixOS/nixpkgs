{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "csview";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-O6IJGfJwGdtxLyUTFNHp9rGy05gVLlQTS8bTRsSYIuY=";
  };

  cargoHash = "sha256-jwkoyvelxl2lJoOHznZDmd39GJMye/+vi7PjrzjlLk4=";

  meta = with lib; {
    description = "A high performance csv viewer with cjk/emoji support";
    homepage = "https://github.com/wfxr/csview";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
