{buildGoModule, fetchFromGitHub, lib}:
buildGoModule rec {
  pname = "cf-vault";
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "jacobbednarz";
    repo = pname;
    rev = version;
    sha256 = "sha256-+6+I69LRCoU35lTrM8cZnzJsHB9SIr6OQKaiRFo7aW4=";
  };

  vendorHash = "sha256-oNLGHV0NFYAU1pHQWeCmegonkEtMtGts0uWZWPnLVuY=";

  meta = with lib; {
    description = ''
      A tool for managing your Cloudflare credentials, securely..
    '';
    homepage = "https://github.com/jacobbednarz/cf-vault/";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
  };
}
