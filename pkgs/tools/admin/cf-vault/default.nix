{buildGoModule, fetchFromGitHub, lib}:
buildGoModule rec {
  pname = "cf-vault";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "jacobbednarz";
    repo = pname;
    rev = version;
    sha256 = "sha256-wW/CSF+DexrdmOvp3BpyBmltOyF4TBTW3OXwjdqfaR4=";
  };

  vendorSha256 = "sha256-H44YCoay/dVL22YhMy2AT/Jageu0pM9IS0SWPp9E4F8=";

  meta = with lib; {
    description = ''
      A tool for managing your Cloudflare credentials, securely..
    '';
    homepage = "https://github.com/jacobbednarz/cf-vault/";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
  };
}
