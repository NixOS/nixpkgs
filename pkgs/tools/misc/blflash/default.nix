{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "blflash";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "spacemeowx2";
    repo = "blflash";
    rev = "v${version}";
    sha256 = "sha256-hPScmivtugtZm848Itzg4Tb9rppZny+rKi3IBuUxxQY=";
  };

  cargoSha256 = "sha256-/y3R8B2TOf8jeB9tcewoA9EGN6kj/EPMTjU6rfTF5Vc=";

  meta = with lib; {
    description = "An bl602 serial flasher written in Rust";
    homepage = "https://github.com/spacemeowx2/blflash";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
