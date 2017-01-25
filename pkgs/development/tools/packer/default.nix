{ stdenv, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  name = "packer-${version}";
  version = "0.12.1";

  goPackagePath = "github.com/mitchellh/packer";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "mitchellh";
    repo = "packer";
    rev = "v${version}";
    sha256 = "05wd8xf4nahpg96wzligk5av10p0xd2msnb3imk67qgbffrlvmvi";
  };

  meta = with stdenv.lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = http://www.packer.io;
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ];
    platforms   = platforms.unix;
  };
}
