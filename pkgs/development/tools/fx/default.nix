{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fx";
  version = "24.0.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = pname;
    rev = version;
    sha256 = "sha256-Sg+mluDOGpkEUl+3BoItuPnMqs8F6o+D5xIqF0w0EIU=";
  };

  vendorSha256 = "sha256-4hx1AZQQ4xHBTzBK0OmrTUGMK4Rfu36cmopVV4SOjCQ=";

  meta = with lib; {
    description = "Terminal JSON viewer";
    homepage = "https://github.com/antonmedv/fx";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
