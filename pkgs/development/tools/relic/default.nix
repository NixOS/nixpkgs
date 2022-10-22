{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "relic";
  version = "7.5.3";

  src = fetchFromGitHub {
    owner = "sassoftware";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-urueDWvHhDsIiLIAatAforBM//UEJz8wUHEVyhwV7JY=";
  };

  vendorSha256 = "sha256-wlylASK2RES0nbf6UZHJBrYQaz9jrq5j7/KF1wYOqE0=";

  meta = with lib; {
    homepage = "https://github.com/sassoftware/relic";
    description = "A service and a tool for adding digital signatures to operating system packages for Linux and Windows";
    license = licenses.asl20;
    maintainers = with maintainers; [ strager ];
    platforms = platforms.unix;
  };
}
