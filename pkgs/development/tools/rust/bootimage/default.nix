{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "bootimage";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "12p18mk3l473is3ydv3zmn6s7ck8wgjwavllimcpja3yjilxm3zg";
  };

  cargoSha256 = "03jximwqgjq7359c5mxbyfja2d04y57h34f87aby8jy0lz99jy2x";

  meta = with lib; {
    description = "Creates a bootable disk image from a Rust OS kernel";
    homepage = "https://github.com/rust-osdev/bootimage";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ dbeckwith ];
  };
}
