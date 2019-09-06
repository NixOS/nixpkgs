{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  pname = "rainicorn";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "RustDT";
    repo = "Rainicorn";
    rev = "0f8594079a7f302f4940cc4320f5e4f39f95cdc4";
    sha256 = "07vh4g120sx569wkzclq91blkkd7q7z582pl8vz0li1l9ij8md01";
  };

  cargoSha256 = "07zsj12g4ff0cdb9pwz302vxvajr8g6nl3bpz4vdyi84csfvmahz";

  meta = with stdenv.lib; {
    broken = true;
    description = "Rust IDEs.  parse-analysis";
    homepage = https://github.com/RustDT/Rainicorn;
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
  };
}
