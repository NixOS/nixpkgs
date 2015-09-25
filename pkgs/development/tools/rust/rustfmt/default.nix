{ stdenv, fetchgit, rustUnstable, makeWrapper, llvmPackages_37 }:

with rustUnstable;

buildRustPackage rec {
  name = "rustfmt-git-2015-09-23";
  src = fetchgit {
    url = https://github.com/nrc/rustfmt;
    rev = "c14cfca0e3de3dfa5fd91d39a85c5b452e7756e3";
    sha256 = "0q72mfj2ph2n4cd0cs4p2mpyr2ixd6ss607kjlgfinjv6klk1i3b";
  };

  buildInputs = [ llvmPackages_37.llvm ];

  depsSha256 = "13i9qaia1wn18lgfl69rrxw7b24bq1bpqhdck2jzxpv3wi2xshlw";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/nrc/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
  };
}
