{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rust-script";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "fornwall";
    repo = pname;
    rev = version;
    sha256 = "sha256-BQ/jgS7tq4upVe78N3rxNIQPq/4RHtt66wBnltcU/iY=";
  };

  cargoSha256 = "sha256-bU/LKvixAu6GQ93FT8csQFFnfHDhFltWHXfG/Pmchfw=";

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
