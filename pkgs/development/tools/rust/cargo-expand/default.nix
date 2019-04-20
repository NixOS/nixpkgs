{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "0.4.11";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "051hy2320mqdxvafhafwnk1n8q2sq2d7jyhx5bbxvqmjjm55lg8h";
  };

  cargoSha256 = "0d1j01nrq5j0yrgd85lnvg1mzalcd8xadkza3yvwnqzf554idrcy";

  meta = with stdenv.lib; {
    description = "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = https://github.com/dtolnay/cargo-expand;
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ xrelkd ];
  };
}
