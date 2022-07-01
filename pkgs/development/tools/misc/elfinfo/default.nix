{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "elfinfo";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "elfinfo";
    rev = version;
    sha256 = "1n8bg0rcq9fqa6rdnk6x9ngvm59hcayblkpjv9j5myn2vmm6fv8m";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Small utility for showing information about ELF files";
    homepage = "https://elfinfo.roboticoverlords.org/";
    changelog = "https://github.com/xyproto/elfinfo/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
