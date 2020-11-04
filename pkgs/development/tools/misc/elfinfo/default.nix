{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "elfinfo";
  version = "1.1.0";

  goPackagePath = "github.com/xyproto/elfinfo";
  src = fetchFromGitHub {
    rev = version;
    owner = "xyproto";
    repo = "elfinfo";
    sha256 = "1n8bg0rcq9fqa6rdnk6x9ngvm59hcayblkpjv9j5myn2vmm6fv8m";
  };

  meta = with stdenv.lib; {
    description = "Small utility for showing information about ELF files";
    homepage = "https://elfinfo.roboticoverlords.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
