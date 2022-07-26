{ lib, buildGoModule, fetchFromGitHub, libpcap }:

buildGoModule rec {
  pname = "goreplay";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "buger";
    repo = "goreplay";
    rev = version;
    sha256 = "sha256-FiY9e5FgpPu+K8eoO8TsU3xSaSoPPDxYEu0oi/S8Q1w=";
  };

  vendorSha256 = "sha256-jDMAtcq3ZowFdky5BdTkVNxq4ltkhklr76nXYJgGALg=";

  ldflags = [ "-s" "-w" ];

  buildInputs = [ libpcap ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/buger/goreplay";
    license = lib.licenses.lgpl3Only;
    description = "Open-source tool for capturing and replaying live HTTP traffic";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ lovek323 ];
  };
}
