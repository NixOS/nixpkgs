{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "elfinfo";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "elfinfo";
    rev = version;
    sha256 = "sha256-vnlPSNyabFjucxHU1w5EPIO9UmTiuCKEzGMC+EZRTtM=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Small utility for showing information about ELF files";
    homepage = "https://elfinfo.roboticoverlords.org/";
    changelog = "https://github.com/xyproto/elfinfo/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
