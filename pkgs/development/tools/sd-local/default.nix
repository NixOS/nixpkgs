{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "sd-local";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = pname;
    rev = "v${version}";
    sha256 = "09j1wcx66sz2b0pps0bgbay5x06lc0d2awxjvd5zi8wqnbsrdq60";
  };

  vendorSha256 = "1qy51jx181rwim2v53ysgf7rys0nmxsbawvsbh3z1ihh3dlgw5bc";

  subPackages = [ "." ];

  meta = with lib; {
    description = "screwdriver.cd local mode";
    homepage = "https://github.com/screwdriver-cd/sd-local";
    license = licenses.bsd3;
    maintainers = with maintainers; [ midchildan ];
  };
}
