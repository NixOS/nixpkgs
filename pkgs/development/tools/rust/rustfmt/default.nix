{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "rustfmt-git-2015-12-08";
  src = fetchFromGitHub {
    owner = "nrc";
    repo = "rustfmt";
    rev = "e94bd34a06d878a41bb8be409f173a8824dda63f";
    sha256 = "0f0ixbr5nfla0j0b91plmapw75yl3d3lxwvllj2wx4z94nfxanp6";
  };

  depsSha256 = "0vsrpw4icn9jf44sqr5749hbazsxp3hqn1g7gr90fvnfvz4s5f07";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/nrc/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
  };
}
