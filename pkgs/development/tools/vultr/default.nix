{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "vultr";
  version = "2.0.1";
  goPackagePath = "github.com/JamesClonk/vultr";

  src = fetchFromGitHub {
    owner = "JamesClonk";
    repo = "vultr";
    rev = "v${version}";
    sha256 = "16wlncf0wax5jhpbfif5k16knigxy89vcby0b821klv6hlm6cc58";
  };

  meta = {
    description = "A command line tool for Vultr services, a provider for cloud virtual private servers";
    homepage = "https://github.com/JamesClonk/vultr";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.zauberpony ];
  };
}
