{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "csview";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-v+WqiHecps3rCGf6CF0KJDZUWs7zMrFypVPTANR8b6Y=";
  };

  cargoHash = "sha256-v5QxJto9acVJnMUvBK3QdkDH+qO2+wtqitGfSCcaJ5w=";

  meta = with lib; {
    description = "A high performance csv viewer with cjk/emoji support";
    mainProgram = "csview";
    homepage = "https://github.com/wfxr/csview";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
