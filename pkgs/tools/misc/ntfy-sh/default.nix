{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ntfy-sh";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "sha256-rXdkNJYpQ8s2BeFRR4fSIuCrdq60me4B3wee64ei8qM=";
  };

  vendorSha256 = "sha256-7b3cQczQLUZ//5ubKvq8s9U75qJpJaieLN+kzjXIyHg=";

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
