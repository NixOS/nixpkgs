{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vultr-${version}";
  version = "1.13.0";
  goPackagePath = "github.com/JamesClonk/vultr";

  src = fetchFromGitHub {
    owner = "JamesClonk";
    repo = "vultr";
    rev = "${version}";
    sha256 = "0xjalxl2yncrhbh4m2gyg3cahv3wvq782qd668vim6qks676d9nx";
  };

  meta = {
    description = "A command line tool for Vultr services, a provider for cloud virtual private servers";
    homepage = "https://github.com/JamesClonk/vultr";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.zauberpony ];
  };
}
