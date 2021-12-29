{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "csview";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ezN/hU8SdC/ox+l1KJQixzFwGvfmg3zfUjf/bAtnYRU=";
  };

  cargoSha256 = "sha256-gEiZIwISlazkBwQPFaIWM6dViumc55no8RQ8E30JfUo=";

  meta = with lib; {
    description = "A high performance csv viewer with cjk/emoji support";
    homepage = "https://github.com/wfxr/csview";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
