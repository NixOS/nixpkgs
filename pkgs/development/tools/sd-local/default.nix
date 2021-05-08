{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "sd-local";
  version = "1.0.31";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2EhXhgSm6rCCXNBCf0BH+MzHeU7n/XAXYXosCjRGEbo=";
  };

  vendorSha256 = "sha256-4xuWehRrmVdS2F6r00LZLKq/oHlWqCTQ/jYUKeIJ6DI=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "screwdriver.cd local mode";
    homepage = "https://github.com/screwdriver-cd/sd-local";
    license = licenses.bsd3;
    maintainers = with maintainers; [ midchildan ];
  };
}
