{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rust-script";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "fornwall";
    repo = pname;
    rev = version;
    sha256 = "sha256-c55MiXpMnOsMUI5Bg6k8Ta9iT3G+ixzfMbj9T17OKAY=";
  };

  cargoSha256 = "sha256-yuwerF4gICPSpwopB4iMheXC7SMtX7IgSEgRwJ/gJdg=";

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Run Rust files and expressions as scripts without any setup or compilation step";
    homepage = "https://rust-script.org";
    changelog = "https://github.com/fornwall/rust-script/releases/tag/${version}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
