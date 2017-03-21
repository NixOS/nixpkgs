{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "rustfmt-${version}";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustfmt";
    rev = version;
    sha256 = "0a613x1ckwl30yamba9m7xi3xrn8pg92p2w3v7k723whyivmjk1s";
  };

  depsSha256 = "1vach2xf0cs7nivbakhmrm2aqdif3i5vg1syffrs2ghcix9hd21p";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/rust-lang-nursery/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
    platforms = platforms.all;
  };
}
