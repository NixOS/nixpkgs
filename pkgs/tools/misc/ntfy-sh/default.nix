{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ntfy-sh";
  version = "1.27.2";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "sha256-0b4yC2kXh3c2SgKF11voWZh2qS3Y/4KJlt9WtjXswcE=";
  };

  vendorSha256 = "sha256-PXYSjhMNtDa0uCaLu0AyM1SMhZPr2wC+xMPDjeQIhDU=";

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
