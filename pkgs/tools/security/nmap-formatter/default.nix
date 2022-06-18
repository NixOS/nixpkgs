{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nmap-formatter";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ePhm1qwluHhMC0oS/qEHkZv04nAdh2IDSkIW507MLjo=";
  };

  vendorSha256 = "sha256-zkPXjCC+ZdR14O60ZaGFYdEZVxQ5z99HVmLOR10qqfg=";

  meta = with lib; {
    description = "Tool that allows you to convert nmap output";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
