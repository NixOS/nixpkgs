{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = "${version}";
    sha256 = "00ing1v6vjqfvirp3mbayn8rwvxf72wnhz9249k2iifw8bl2r2hd";
  };

  cargoSha256 = "1wmw7knkx79fbwizaj9qkcnw0ld1lsfhca8mfpn5f0daxa5v5y97";

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs ];
    platforms = platforms.all;
  };
}
