{ stdenv, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  name = "packer-${version}";
  version = "1.3.1";

  goPackagePath = "github.com/hashicorp/packer";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    sha256 = "0aif4ilzfv8qyqk4mn525r38xw2w34ryknzd2vrg6mcjcarm8myq";
  };

  meta = with stdenv.lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = https://www.packer.io;
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ];
    platforms   = platforms.unix;
  };
}
