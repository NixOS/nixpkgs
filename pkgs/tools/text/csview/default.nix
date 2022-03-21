{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "csview";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tllwFUC+Si3PsYPmiO86D3PNdInuIxxhZW5dAuU4K14=";
  };

  cargoSha256 = "sha256-j9CwldmxjWYVuiWfAHIV0kr5k/p1BFWHzZiVrv8m7uI=";

  meta = with lib; {
    description = "A high performance csv viewer with cjk/emoji support";
    homepage = "https://github.com/wfxr/csview";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
