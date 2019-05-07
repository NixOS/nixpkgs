{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "0.4.12";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "0m57v7mh7wdl0rdbad7vkvcgy93p9gcb971wap8i5nzjvzmp4wlb";
  };

  cargoSha256 = "1wvqxj2w02d6zhyw3z5v0w4bfmbmldh63ygmvfxa3ngfb36gcacz";

  meta = with stdenv.lib; {
    description = "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = https://github.com/dtolnay/cargo-expand;
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ xrelkd ];
  };
}
