{buildGoModule, fetchFromGitHub, lib}:
buildGoModule rec {
  pname = "cf-vault";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "jacobbednarz";
    repo = pname;
    rev = version;
    sha256 = "sha256-Imd9qeT4xg5ujVPLHSSqoteSPl9t97q3Oc4C/vzHphg=";
  };

  vendorSha256 = "sha256-PkmbVg5HnsUaSL/Kp3YJVdyzpjgvr/p9mKNmOubwXQA=";

  meta = with lib; {
    description = ''
      A tool for managing your Cloudflare credentials, securely..
    '';
    homepage = "https://github.com/jacobbednarz/cf-vault/";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
  };
}
