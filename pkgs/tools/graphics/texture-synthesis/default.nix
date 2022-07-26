{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "texture-synthesis";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "embarkstudios";
    repo = pname;
    rev = version;
    sha256 = "0n1wbxcnxb7x5xwakxdzq7kg1fn0c48i520j03p7wvm5x97vm5h4";
  };

  cargoSha256 = "1xszis3ip1hymzbhdili2hvdwd862cycwvsxxyjqmz3g2rlg5b64";

  meta = with lib; {
    description = "Example-based texture synthesis written in Rust";
    homepage = "https://github.com/embarkstudios/texture-synthesis";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
