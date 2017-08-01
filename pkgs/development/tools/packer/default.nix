{ stdenv, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  name = "packer-${version}";
  version = "1.0.3";

  goPackagePath = "github.com/mitchellh/packer";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "mitchellh";
    repo = "packer";
    rev = "v${version}";
    sha256 = "1bd0rv93pxlv58c0x1d4dsjq4pg5qwrm2p7qw83pca7izlncgvfr";
  };

  meta = with stdenv.lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = http://www.packer.io;
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ];
    platforms   = platforms.unix;
  };
}
