{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "goklp-${version}";
  version = "1.6";

  goPackagePath = "github.com/AppliedTrust/goklp";

  src = fetchFromGitHub {
    owner = "AppliedTrust";
    repo = "goklp";
    rev = "v${version}";
    sha256 = "054qmwfaih8qbvdyy4rqbb1ip3jpnm547n390hgab8yc3bdd840c";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Golang OpenSSH Keys Ldap Provider for AuthorizedKeysCommand";
    homepage = https://github.com/AppliedTrust/goklp;
    maintainers = with maintainers; [ disassembler ];
    license = licenses.bsd2;
  };
}
