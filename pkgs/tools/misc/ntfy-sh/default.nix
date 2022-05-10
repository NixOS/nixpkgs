{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ntfy-sh";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "sha256-30j62GaO5SXG78c6vMpLZ+ixy1zesjXoX3L9Et/7uhU=";
  };

  vendorSha256 = "sha256-Sx6l5GJ72A0SHEHyVtlte8Ed9fuJzZAkJzC0zpCbvK8=";

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
