{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "rustfmt-${version}";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustfmt";
    rev = "4418fab4f24e6497aa2a1f71bb4cf963c2971a28";
    sha256 = "0x2kg2sqpj4lsqqskcy5p0w3264f0by1irkjj369ch89xax7l52l";
  };

  depsSha256 = "022mwggmy6p9n8dh22y6m3sadrwvwlbpj9w9ki9avmgsm3cj2mhs";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/rust-lang-nursery/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
    platforms = platforms.all;
  };
}
