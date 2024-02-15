{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "sd-local";
  version = "1.0.52";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2EWLi42ztuohouhMZ3DXa2wHx1tgPAUH0IKbn6lQeF0=";
  };

  vendorHash = "sha256-uHu8jPPQCJAhXE+Lzw5/9wyw7sL5REQJsPsYII+Nusc=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "screwdriver.cd local mode";
    homepage = "https://github.com/screwdriver-cd/sd-local";
    license = licenses.bsd3;
    maintainers = with maintainers; [ midchildan ];
  };
}
