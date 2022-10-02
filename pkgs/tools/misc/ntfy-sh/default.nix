{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ntfy-sh";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "sha256-pDKeG0Q4cG+UoxpBawHOtO8xVXXxo0Z7nyY2nZSSFvc=";
  };

  vendorSha256 = "sha256-oMZCjrCsq6aRxcdF6jQK51sZqOjbrdlbofSQvGO/POg=";

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
