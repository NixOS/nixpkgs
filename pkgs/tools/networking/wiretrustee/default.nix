{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wiretrustee";
  version = "0.2.0-beta.1";

  src = fetchFromGitHub {
    owner = "wiretrustee";
    repo = "wiretrustee";
    rev = "v${version}";
    sha256 = "13zn8544vj9ag2nws02zm4bm5f2mkargc3i0p0d3n9q2zlpc3q4c";
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
