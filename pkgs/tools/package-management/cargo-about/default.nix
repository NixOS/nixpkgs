{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
    sha256 = "1jdp5ksxm4rsqhirgl5zwpiahrz2lx046pkvf6xvr6ms70l2xiwj";
  };

  cargoSha256 = "1m2i1ryzcbzwsghlxk68ivxzfb9jfv427vx0zsqkw68chgwrb40n";

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs ];
  };
}
