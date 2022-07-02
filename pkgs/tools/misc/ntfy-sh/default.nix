{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ntfy-sh";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "sha256-LR3orzh/xwmxt5RhmjOacFs8NUp6tKPUwYDdzVFhx4k=";
  };

  vendorSha256 = "sha256-16S3Up1D4PycBY2Wk11cm0F4z5PkQL2reXj1mGpsOv4=";

  doCheck = false;

  preBuild = ''
    make cli-deps-static-sites
  '';

  meta = with lib; {
    description = "Send push notifications to your phone or desktop via PUT/POST";
    homepage = "https://ntfy.sh";
    license = licenses.asl20;
    maintainers = with maintainers; [ arjan-s ];
  };
}
