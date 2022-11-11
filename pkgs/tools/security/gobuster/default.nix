{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gobuster";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "OJ";
    repo = "gobuster";
    rev = "v${version}";
    hash = "sha256-bh48TAhK0HwwNvE5Fr4KtCI+Nz1Wb9vaV916RzGG8/I=";
  };

  vendorHash = "sha256-fuz9Sj/wKJWp7Q/g5LBb44a50QKGMCPHJ38TBhTCn00=";

  meta = with lib; {
    description = "Tool used to brute-force URIs, DNS subdomains, Virtual Host names on target web servers";
    homepage = "https://github.com/OJ/gobuster";
    license = licenses.asl20;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
