{ stdenv, fetchFromGitHub, rustUnstable, makeWrapper }:

with rustUnstable;

buildRustPackage rec {
  name = "rustfmt-git-2015-10-17";
  src = fetchFromGitHub {
    owner = "nrc";
    repo = "rustfmt";
    rev = "36c9a3acf95a036f3f9fa72ff3fe175fba55e20b";
    sha256 = "1vjnfq3al73qljalr2rvymabcksx6y690gg5r9kgz1lnizlb7yrz";
  };

  depsSha256 = "0vzpq58vfswdwdm2bk44ynk43cmwdxppcbkvpjyfa6sjs2s5x8n9";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/nrc/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
  };
}
