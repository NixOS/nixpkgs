{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "2fa";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "rsc";
    repo = "2fa";
    rev = "v${version}";
    sha256 = "sha256-cB5iADZwvJQwwK1GockE2uicFlqFMEAY6xyeXF5lnUY=";
  };

  deleteVendor = true;
  vendorHash = "sha256-4h/+ZNxlJPYY0Kyu2vDE1pDXxC/kGE5JdnagWVOGzAE=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://rsc.io/2fa";
    description = "Two-factor authentication on the command line";
    mainProgram = "2fa";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
