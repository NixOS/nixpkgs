{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "rustfmt-${version}";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustfmt";
    rev = "19768da5c97c108a05e6f545b73ba4b76d1b1788";
    sha256 = "0f2m0gvlqlybcjl2xqwxlp5hjkhd30kx25dq56k5x0r3808ijksg";
  };

  depsSha256 = "1lbcpvp7xhyl96w7jfd18w6py60nwllr93jna5j33zvnip61cpf5";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/nrc/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
  };
}
