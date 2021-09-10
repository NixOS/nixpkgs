{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-sort";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "devinr528";
    repo = pname;
    rev = "v${version}";
    sha256 = "146aawikyjcxbj0dpnqia31xmplpwkl9w1gv7d9a5jvz8whvxrff";
  };

  cargoSha256 = "0xm37f285vmd674k5j72pcjg6zpmxlf46d9vppi9s3qaw0hsslpf";

  meta = with lib; {
    description = "A tool to check that your Cargo.toml dependencies are sorted alphabetically";
    homepage = "https://github.com/devinr528/cargo-sort";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
