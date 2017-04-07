{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "rustfmt-${version}";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustfmt";
    rev = "v${version}";
    sha256 = "05rjx7i4wn3z3j8bgqsn146a9vbni6xhxaim9nq13c6dm4nrx96b";
  };

  depsSha256 = "1rnk33g85r1hkw9l9c52dzr4zka5kghbci9qwni3ph19rfqf0a73";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/rust-lang-nursery/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
    platforms = platforms.all;
  };
}
