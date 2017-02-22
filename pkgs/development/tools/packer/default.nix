{ stdenv, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  name = "packer-${version}";
  version = "0.12.2";

  goPackagePath = "github.com/mitchellh/packer";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "mitchellh";
    repo = "packer";
    rev = "v${version}";
    sha256 = "1li141y7rfbn021h33dnryhms5xwzqz8d92djnprbh7ba9ff02zm";
  };

  meta = with stdenv.lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = http://www.packer.io;
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ];
    platforms   = platforms.unix;
  };
}
