{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage {
  pname = "itm";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "rust-embedded";
    repo = "itm";
    rev = "96d7710f2ba8f915668e95d67e0def961567c195";
    sha256 = "15pa0ydm19vz8p3wairpx3vqzc55rp4lgki143ybgw44sgf8hraj";
  };

  cargoSha256 = "1d748vh1ig8r0cd70lsnw9fdmanic4jxxibbbagd5mrh8462v64v";
  cargoPatches = [ ./cargo_lock.patch ];

  meta = with lib; {
    description = "A Rust crate and tool itmdump to parse and dump ARM ITM packets";
    homepage = "https://github.com/rust-embedded/itm";
    license = licenses.asl20;
    maintainers = with maintainers; [
      davidarmstronglewis
    ];
  };
}
