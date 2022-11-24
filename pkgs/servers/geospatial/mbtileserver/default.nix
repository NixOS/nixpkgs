{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mbtileserver";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "consbio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HGzgqUH9OxwjfYR9I9JzcP11+SB8A3hC/3Uk1dOCq+k=";
  };

  vendorSha256 = "sha256-vuNOOPVGUkmKJ477N20DvhJTcMIW1lNmrgJLeMpNImM=";

  meta = with lib; {
    description = "A simple Go-based server for map tiles stored in mbtiles format";
    homepage = "https://github.com/consbio/mbtileserver";
    changelog = "https://github.com/consbio/mbtileserver/blob/v${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
