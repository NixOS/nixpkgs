{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mask";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "jacobdeichert";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mlARZ05xppPvr6Z5uoveYt3Y3LtdMkbFqxW1EkX+ud0=";
  };

  cargoSha256 = "sha256-EulRz/IjLLvNT9YxyNjJynFEGyQ/Q2Out984xS9Wp5o=";

  # tests require mask to be installed
  doCheck = false;

  meta = with lib; {
    description = "A CLI task runner defined by a simple markdown file";
    homepage = "https://github.com/jacobdeichert/mask";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
