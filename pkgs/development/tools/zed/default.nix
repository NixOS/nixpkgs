{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zed";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "brimdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DVQoWam5szELJ3OeIKHYF0CBZ0AJlhuIJRrdhqmyhQM=";
  };

  vendorSha256 = "sha256-2zSSjAoeb+7Nk/dxpvp5P2/bSJXgkA0TieTQHK4ym1Y=";

  subPackages = [ "cmd/zed" "cmd/zq" ];

  meta = with lib; {
    description = "A novel data lake based on super-structured data";
    homepage = "https://github.com/brimdata/zed";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya ];
    changelog = "https://github.com/brimdata/zed/blob/v${version}/CHANGELOG.md";
  };
}
