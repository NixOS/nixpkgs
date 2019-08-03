{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "jid-${version}";
  version = "0.7.2";

  goPackagePath = "github.com/simeji/jid";

  src = fetchFromGitHub {
    owner = "simeji";
    repo = "jid";
    rev = "${version}";
    sha256 = "0p4srp85ilcafrn9d36rzpzg5k5jd7is93p68hamgxqyiiw6a8fi";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "A command-line tool to incrementally drill down JSON";
    homepage = https://github.com/simeji/jid;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ stesie ];
  };
}
