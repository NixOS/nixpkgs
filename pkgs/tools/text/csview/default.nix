{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "csview";
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1j3u9r5TjdewAyzuCwCkXl/A2yI9L/AS5QGRpz30N7U=";
  };

  cargoSha256 = "sha256-Z+LnWXvVfZa8Mtr9LrieqCBGxaQE1vj1joSttYM5Xhs=";

  meta = with lib; {
    description = "A high performance csv viewer with cjk/emoji support";
    homepage = "https://github.com/wfxr/csview";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
