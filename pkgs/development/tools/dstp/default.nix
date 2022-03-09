{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dstp";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ycd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YvuUgHHa8Egk+bbSI0SH0i3YrKWRbzjAckNG32RBRXw=";
  };

  vendorSha256 = "sha256-qNH71MPKOC0ld7xxppjZrHSTJ6t8E0LljM1OzT7pM9g=";

  # Tests require network connection, but is not allowed by nix
  doCheck = false;

  meta = with lib; {
    description = "Run common networking tests against your site";
    homepage = "https://github.com/ycd/dstp";
    license = licenses.mit;
    maintainers = with maintainers; [ jlesquembre ];
  };
}
