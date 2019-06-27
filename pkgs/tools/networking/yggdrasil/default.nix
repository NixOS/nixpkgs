{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "yggdrasil";
  version = "0.3.5";

  goPackagePath = "github.com/yggdrasil-network/yggdrasil-go";

  subPackages = [ "cmd/yggdrasil" "cmd/yggdrasilctl" ];

  src = fetchFromGitHub {
    owner = "yggdrasil-network";
    repo = "yggdrasil-go";
    rev = "v${version}";
    sha256 = "0cbj9hqrgn93jlybf3mfpffb68yyizxlvrsh1s5q21jv2lhhjcwj";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "An experiment in scalable routing as an encrypted IPv6 overlay network";
    homepage = "https://yggdrasil-network.github.io/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ lassulus ];
  };
}
