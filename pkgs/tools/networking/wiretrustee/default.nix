{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wiretrustee";
  version = "0.2.2-beta.1";

  src = fetchFromGitHub {
    owner = "wiretrustee";
    repo = "wiretrustee";
    rev = "v${version}";
    sha256 = "1n2hy91f7y32nw7m32vbm9sxh3c0qg4f3pzfd2w7dzk7vl6zrvk7";
  };

  vendorSha256 = "1sz5lbw0cvzspg19n45x8kx5xhs26hf2a726ls1byc6r5cg52hcw";

  doCheck = false;

  meta = with lib; {
    description = "Connect your devices into a single secure private WireGuard-based mesh network";
    homepage = "https://github.com/wiretrustee/wiretrustee";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
