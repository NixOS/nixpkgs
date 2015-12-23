{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "rustfmt-git-2015-12-23";
  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustfmt";
    rev = "c0b7de7c521dc65b2ad2b5a3c81fb56030f4af22";
    sha256 = "1axnp8w26c3dwlx7bby3qi6385n301rlk1ndh5yaz7vkbpn4w9km";
  };

  depsSha256 = "1s2as7qc7jbksc16gj5cxxm52zw8h4nfgka66dmwwjlv9679wj9f";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/nrc/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
  };
}
