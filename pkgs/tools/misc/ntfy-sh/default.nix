{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ntfy-sh";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "sha256-JwRI58FadN7DH4MOO033EYmcbqCIuPxw5wWeafoInSg=";
  };

  vendorSha256 = "sha256-nzcCLDN/vJ6DS6isCSLL9ycxFkIyUwy4Um6M7NWAPTk=";

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
