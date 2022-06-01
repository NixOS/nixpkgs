{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ntfy-sh";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "sha256-Jw+8rgbevtk1Mzy/g+DryAk7a/RbQXpEtwPlqJRD/UM=";
  };

  vendorSha256 = "sha256-MdbC+Hv8jSImg0d2HMeAmUdWLQT8+zSe+0mkIwHIJXM=";

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
