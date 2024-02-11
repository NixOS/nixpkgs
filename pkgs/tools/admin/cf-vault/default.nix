{buildGoModule, fetchFromGitHub, lib}:
buildGoModule rec {
  pname = "cf-vault";
  version = "0.0.18";

  src = fetchFromGitHub {
    owner = "jacobbednarz";
    repo = pname;
    rev = version;
    sha256 = "sha256-vp9ufjNZabY/ck2lIT+QpD6IgaVj1BkBRTjPxkb6IjQ=";
  };

  vendorHash = "sha256-7qFB1Y1AnqMgdu186tAXCdoYOhCMz8pIh6sY02LbIgs=";

  meta = with lib; {
    description = ''
      A tool for managing your Cloudflare credentials, securely..
    '';
    homepage = "https://github.com/jacobbednarz/cf-vault/";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
  };
}
