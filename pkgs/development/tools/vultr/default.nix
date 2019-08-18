{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "vultr";
  version = "1.15.0";
  goPackagePath = "github.com/JamesClonk/vultr";

  src = fetchFromGitHub {
    owner = "JamesClonk";
    repo = "vultr";
    rev = "${version}";
    sha256 = "1bx2x17aa6wfn4qy9lxk8sh7shs3x5ppz2z49s0xm8qq0rs1qi92";
  };

  meta = {
    description = "A command line tool for Vultr services, a provider for cloud virtual private servers";
    homepage = https://github.com/JamesClonk/vultr;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.zauberpony ];
  };
}
