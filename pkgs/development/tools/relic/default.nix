{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "relic";
  version = "7.4.0";

  src = fetchFromGitHub {
    owner = "sassoftware";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3YzZUwS2rU+OROMXuIbVeLDQMIpEmZz+PNnI4dbQs+Y=";
  };

  vendorSha256 = "sha256-aguirMJgh/uAGl0l3wKBMH2QEIH2N8pq7Dl9Ngfkc90=";

  meta = with lib; {
    homepage = "https://github.com/sassoftware/relic";
    description = "A service and a tool for adding digital signatures to operating system packages for Linux and Windows";
    license = licenses.asl20;
    maintainers = with maintainers; [ strager ];
    platforms = platforms.unix;
  };
}
