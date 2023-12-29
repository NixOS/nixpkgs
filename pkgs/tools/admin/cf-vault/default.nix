{buildGoModule, fetchFromGitHub, lib}:
buildGoModule rec {
  pname = "cf-vault";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "jacobbednarz";
    repo = pname;
    rev = version;
    sha256 = "sha256-wSTbg+dQrTbfL4M4XdwZXS04mjIFtD0RY1vK0CUHkso=";
  };

  vendorHash = "sha256-b9Ni4H2sk2gU+0zLOBg0P4ssqSJYTHnAvnmMHXha5us=";

  meta = with lib; {
    description = ''
      A tool for managing your Cloudflare credentials, securely..
    '';
    homepage = "https://github.com/jacobbednarz/cf-vault/";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
  };
}
