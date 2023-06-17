{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vultr-cli";
  version = "2.16.2";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TugONG98MC1+B9kDLH9xeMmD41fHNV8VCWWWtOdlwys=";
  };

  vendorHash = "sha256-P4xr7zVTwBRVoPxtKn3FNV7Vp6lI4uWdTJyXwex8Fe4=";

  meta = with lib; {
    description = "Official command line tool for Vultr services";
    homepage = "https://github.com/vultr/vultr-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
