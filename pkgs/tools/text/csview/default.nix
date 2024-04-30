{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "csview";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Tu/h9jhZgulrc5bTJrwq7Ksg69qUVUBjWNdzve4m9JM=";
  };

  cargoHash = "sha256-ZXLu/6IQ20u8dk0gaZoBh0rt6CGaRBNVHGgrCW5+yzA=";

  meta = with lib; {
    description = "A high performance csv viewer with cjk/emoji support";
    mainProgram = "csview";
    homepage = "https://github.com/wfxr/csview";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
