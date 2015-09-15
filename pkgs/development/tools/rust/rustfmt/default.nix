{stdenv, fetchgit, rustUnstable, makeWrapper }:

with rustUnstable;

buildRustPackage rec {
  name = "rustfmt-git-2015-09-05";
  src = fetchgit {
    url = https://github.com/nrc/rustfmt;
    rev = "6c5d3500bb805b37865fe961a7054f8435d176fc";
    sha256 = "0y506viir1klzvspi49qawrfd2g12p9ff2fyy1ndba6zixf69a90";
  };

  depsSha256 = "1kfc9l176qkimaag9p650sfpaz50p263rw2021gq5kjw8cyndlx8";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/nrc/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
  };
}
