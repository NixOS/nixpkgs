{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudlist";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CYEQ+hHFKSHuW2U//59g+oHkxRzVOZzipkOB6KueHvA=";
  };

  vendorSha256 = "sha256-pZsRpvSDGpfEVgszB52cZS5Kk+REeLnw3qsyGGVZoa0=";

  meta = with lib; {
    description = "Tool for listing assets from multiple cloud providers";
    homepage = "https://github.com/projectdiscovery/cloudlist";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
