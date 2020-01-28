{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = "${version}";
    sha256 = "1n9274np1ibz1s35q1qqajnwj7w4l695js9xdbga5wim18ly622m";
  };

  cargoSha256 = "0zjvvqw68y6zmjzmd22hh246422x2kxljj73vxywkl18crkakd7k";

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs ];
    platforms = platforms.all;
  };
}
