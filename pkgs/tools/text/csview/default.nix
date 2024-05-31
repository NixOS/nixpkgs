{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "csview";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ci0PyTZJIEagBCymtrYR/ntgYym1aGKNX4COfrE99mY=";
  };

  cargoHash = "sha256-/pswnb2vNtw8zSoWuC7oZPJ4yxVuy1c4ES1NUHhnG6I=";

  meta = with lib; {
    description = "A high performance csv viewer with cjk/emoji support";
    mainProgram = "csview";
    homepage = "https://github.com/wfxr/csview";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
