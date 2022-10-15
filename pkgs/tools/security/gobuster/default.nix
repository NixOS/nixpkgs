{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gobuster";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "OJ";
    repo = "gobuster";
    rev = "v${version}";
    hash = "sha256-rTduDHGo5V40OlBnwncSzCNYGsHg0uXnuI8JSwOqCSY=";
  };

  vendorHash = "sha256-OYQTVu3L2VxOMIYKMHmjiPCKU15RopLz0KL5+7Zb9WY=";

  meta = with lib; {
    description = "Tool used to brute-force URIs, DNS subdomains, Virtual Host names on target web servers";
    homepage = "https://github.com/OJ/gobuster";
    license = licenses.asl20;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
