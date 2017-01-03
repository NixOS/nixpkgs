{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vultr-${version}";
  version = "1.12.0";
  goPackagePath = "github.com/JamesClonk/vultr";

  src = fetchFromGitHub {
    owner = "JamesClonk";
    repo = "vultr";
    rev = "${version}";
    sha256 = "0fzwzp0vhf3cgl9ij5zpdyn29w9rwwxghr50jjfbagpkfpy4g686";
  };

  meta = {
    description = "A command line tool for Vultr services, a provider for cloud virtual private servers";
    homepage = "https://github.com/JamesClonk/vultr";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.zauberpony ];
  };
}
