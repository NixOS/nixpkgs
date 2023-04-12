{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "xurls";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "xurls";
    rev = "v${version}";
    sha256 = "sha256-lyDcwbdVKyFRfsYCcPAgIgvrEEdwK0lxmJTvMJcFBCw=";
  };

  vendorSha256 = "sha256-lJzgJxW/GW3J09uKQGoEX+UsHnB1pGG71U/zy4b9rXo=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Extract urls from text";
    homepage = "https://github.com/mvdan/xurls";
    maintainers = with maintainers; [ koral ];
    license = licenses.bsd3;
  };
}
