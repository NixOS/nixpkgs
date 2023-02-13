{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gobuster";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "OJ";
    repo = "gobuster";
    rev = "v${version}";
    hash = "sha256-GSpCmJx60DMGr6hDaL//i0gteJniU2jJO+sEDp+eUvg=";
  };

  vendorHash = "sha256-xY+RoM19bsoSCRJk7caMjU3jkUoWkOYRYKHfQjiVVPo=";

  meta = with lib; {
    description = "Tool used to brute-force URIs, DNS subdomains, Virtual Host names on target web servers";
    homepage = "https://github.com/OJ/gobuster";
    changelog = "https://github.com/OJ/gobuster/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
