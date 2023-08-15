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
    sha256 = "sha256-tiQmb7bBWb99k23lS+d+YR14y4YeYPWqccl/2DLv7Dk=";
  };

  vendorSha256 = "sha256-DWGrs/ZKMKgVfwU7W+dktLELbW9Co7cmDy9pWVP5p2w=";

  meta = with lib; {
    description = "Backup all your repositories with Ease.";
    homepage = "https://github.com/cooperspencer/gickup";
    maintainers = with maintainers; [ rhousand ];
    license = licenses.asl20;
  };
}
