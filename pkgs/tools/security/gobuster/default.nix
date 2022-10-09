{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "gobuster";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "OJ";
    repo = "gobuster";
    rev = "v${version}";
    sha256 = "sha256-rTduDHGo5V40OlBnwncSzCNYGsHg0uXnuI8JSwOqCSY=";
  };

  vendorSha256 = "sha256-OYQTVu3L2VxOMIYKMHmjiPCKU15RopLz0KL5+7Zb9WY=";

  meta = with lib; {
    description = "Tool used to brute-force URIs, DNS subdomains, Virtual Host names on target web servers";
    homepage = "https://github.com/OJ/gobuster";
    license = licenses.asl20;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
