{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "sd-local";
  version = "1.0.30";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ha0E0e9CPR8dnApw0cR4A7Tzi3shYVtSeaQ+6I80qcU=";
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
