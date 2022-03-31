{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ntfy-sh";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "sha256-su4Q41x0PrKHRg2R6jxo1KUmWaaLSrU9UZSDsonKNyA=";
  };

  vendorSha256 = "sha256-eZmvngNSYY5Z5Xd5tPXzxv9GkosUMueaBGjZ6L7o/yU=";

  doCheck = false;

  preBuild = ''
    make server-deps-static-sites
  '';

  meta = with lib; {
    description = "Send push notifications to your phone or desktop via PUT/POST";
    homepage = "https://ntfy.sh";
    license = licenses.asl20;
    maintainers = with maintainers; [ arjan-s ];
  };
}
