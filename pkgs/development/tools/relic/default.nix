{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "relic";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "sassoftware";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:0lmxgr9ld6rvqk990c60qh4gb8lr8s77f8i2p4jmp6cf434sc6y0";
  };

  vendorSha256 = "sha256:1l6xxr54rzjfvwmfvpavwzjnscsp532hjqhmdv0l1vx1psdk2aci";

  meta = with lib; {
    homepage = "https://github.com/sassoftware/relic";
    description = "A service and a tool for adding digital signatures to operating system packages for Linux and Windows";
    license = licenses.asl20;
    maintainers = with maintainers; [ strager ];
    platforms = platforms.unix;
  };
}
