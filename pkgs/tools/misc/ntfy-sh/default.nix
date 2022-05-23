{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ntfy-sh";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "sha256-eWVcMHP/YJxlxVRYLfnizbAeCqmtkHGaUG/oibCpDVU=";
  };

  vendorSha256 = "sha256-axuZKkKAnlPQeuTIfYTWF5WqgPYxVttIlFE/e1qv6pc=";

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
