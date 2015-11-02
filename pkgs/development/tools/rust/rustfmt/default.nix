{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "rustfmt-git-2015-10-28";
  src = fetchFromGitHub {
    owner = "nrc";
    repo = "rustfmt";
    rev = "bd0fdbb364ba69c69b867f96bc1ea9b59177fb76";
    sha256 = "07yxz409yxgwrzm46fhq6kyn9igznb7481kxyk90ngmhdd0a5mfd";
  };

  depsSha256 = "0qs6ilpvcrvcmxg7a94rbg9rql1hxfljy6gxrvpn59dy8hb1qccb";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/nrc/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
  };
}
