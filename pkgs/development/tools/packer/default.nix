{ stdenv, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  name = "packer-${version}";
  version = "1.0.0";

  goPackagePath = "github.com/mitchellh/packer";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "mitchellh";
    repo = "packer";
    rev = "v${version}";
    sha256 = "16hdh3iwvdg1jk3pswa9r9lq4qkhds1lrqwl19vd1v2yz2r76kzi";
  };

  meta = with stdenv.lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = http://www.packer.io;
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ];
    platforms   = platforms.unix;
  };
}
