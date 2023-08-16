{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gickup";
  version = "0.10.17";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    rev = "v${version}";
    hash = "sha256-tiQmb7bBWb99k23lS+d+YR14y4YeYPWqccl/2DLv7Dk=";
  };

  vendorHash = "sha256-DWGrs/ZKMKgVfwU7W+dktLELbW9Co7cmDy9pWVP5p2w=";

  meta = with lib; {
    description = "Tool to backup repositories";
    homepage = "https://github.com/cooperspencer/gickup";
    changelog = "https://github.com/cooperspencer/gickup/releases/tag/v${version}";
    maintainers = with maintainers; [ rhousand ];
    license = licenses.asl20;
  };
}
