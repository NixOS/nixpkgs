{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "s-search";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "zquestz";
    repo = "s";
    rev = "v${version}";
    hash = "sha256-VyNxRMStZgmRIwIsfIrp5NhpC+81lkCvfi3RnzgUpnc=";
  };

  vendorHash = "sha256-tyXxnmsl1+XiLGsQrA9dwwnOCc4WQsJakZvIaWyLgEM=";

  ldflags = [ "-s" "-w" ];


  meta = with lib; {
    description = "Open a web search in your terminal";
    homepage = "https://github.com/zquestz/s";
    license = licenses.mit;
    maintainers = with maintainers; [ fedx-sudo ];
  };
}
