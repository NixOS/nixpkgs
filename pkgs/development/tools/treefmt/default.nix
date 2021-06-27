{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "treefmt";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    sha256 = "13z7n0xg150815c77ysz4iqpk8rbgj4vmqy1y2262ryb88dwaw5n";
  };

  cargoSha256 = "1jfrmafj1b28k6xjpj0qq1jpccll0adqxhjypphxhyfsfnra8g6f";

  meta = {
    description = "one CLI to format the code tree";
    homepage = "https://github.com/numtide/treefmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
