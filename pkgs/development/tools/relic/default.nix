{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "relic";
  version = "7.5.4";

  src = fetchFromGitHub {
    owner = "sassoftware";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rm52XrN0554copqIllfaNC9EIZ+6rxVeZWTWR2y9X14=";
  };

  vendorHash = "sha256-389ki4hsx7l2gHSiOHledo/ZP+I3NAkk1K8anq2kfEE=";

  meta = with lib; {
    homepage = "https://github.com/sassoftware/relic";
    description = "A service and a tool for adding digital signatures to operating system packages for Linux and Windows";
    license = licenses.asl20;
    maintainers = with maintainers; [ strager ];
    platforms = platforms.unix;
  };
}
