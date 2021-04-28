{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "blflash";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "spacemeowx2";
    repo = "blflash";
    rev = "v${version}";
    sha256 = "sha256-+2ncK1ibtQwlBREw4Yiqj4vFvAcZqjkoTBtBdAAUoRg=";
  };

  cargoSha256 = "sha256-tt9jfcoEw/HQ0/qU4lhbqKtIw/lthDTcyf/3HYQNPEY=";

  meta = with lib; {
    description = "An bl602 serial flasher written in Rust";
    homepage = "https://github.com/spacemeowx2/blflash";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
