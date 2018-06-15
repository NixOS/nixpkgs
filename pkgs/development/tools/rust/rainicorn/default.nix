{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "rainicorn-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "RustDT";
    repo = "Rainicorn";
    rev = "0f8594079a7f302f4940cc4320f5e4f39f95cdc4";
    sha256 = "07vh4g120sx569wkzclq91blkkd7q7z582pl8vz0li1l9ij8md01";
  };

  cargoSha256 = "14kd25mw6m20blqcr221cclcqxw0j229zxq8hsaay6q7jgv0c7a0";

  meta = with stdenv.lib; {
    broken = true;
    description = "Rust IDEs.  parse-analysis";
    homepage = https://github.com/RustDT/Rainicorn;
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
  };
}
