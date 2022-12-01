{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rust-script";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "fornwall";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5T5DivfT7/MkBJo5YgLAVnfct84nBhw/OXWQ/4TMm2A=";
  };

  cargoSha256 = "sha256-mDH3R9gn64DXVoe3Vkl2Kwhr7OTOUWKBLW5Y+Uo4aXM=";

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Run Rust files and expressions as scripts without any setup or compilation step";
    homepage = "https://rust-script.org";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
