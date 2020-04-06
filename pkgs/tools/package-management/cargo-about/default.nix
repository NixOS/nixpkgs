{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = "${version}";
    sha256 = "0bsay1vqi5b3z7qjwbkwx3ikmpjzc0kswbajm50xmcwlg8jrn420";
  };

  cargoSha256 = "1ynalwaqa70ihgras3frp5l3xniz58hwp108wkxn6zj8lwxbxfgx";

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs ];
    platforms = platforms.all;
  };
}
