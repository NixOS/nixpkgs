{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "dbmate";
  version = "1.4.1";

  goPackagePath = "github.com/amacneil/dbmate";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "v${version}";
    sha256 = "0s3l51kmpsaikixq1yxryrgglzk4kfrjagcpf1i2bkq4wc5gyv5d";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Database migration tool";
    homepage = https://dbmate.readthedocs.io;
    license = licenses.mit;
    maintainers = [ maintainers.manveru ];
    platforms = platforms.unix;
  };
}
