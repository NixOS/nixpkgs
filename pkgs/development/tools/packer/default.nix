{ stdenv, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  pname = "packer";
  version = "1.6.2";

  goPackagePath = "github.com/hashicorp/packer";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    sha256 = "104jw2jcshzds74d7m4yqn6mbk7lgps6qnqmp6h395b1mdyjhink";
  };

  meta = with stdenv.lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = "https://www.packer.io";
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ma27 ];
    platforms   = platforms.unix;
  };
}
