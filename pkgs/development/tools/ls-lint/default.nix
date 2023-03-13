{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ls-lint";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "loeffel-io";
    repo = "ls-lint";
    rev = "v${version}";
    sha256 = "sha256-mt1SvRHtAA0lChZ//8XIQGDPg1l1EOMkPIAe8YKhMSs=";
  };

  vendorSha256 = "sha256-OEwN9kj1npI+H7DY+e3tl5TIY/qr4y2CgAV5fwNA9l4=";

  meta = with lib; {
    description = "An extremely fast file and directory name linter";
    homepage = "https://ls-lint.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
