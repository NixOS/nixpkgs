{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wiretrustee";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "wiretrustee";
    repo = "wiretrustee";
    rev = "v${version}";
    sha256 = "051c234rvjjkadjhwxs7x3lph40pidvkx7si1cvsrlcnyjrcddcy";
  };

  vendorSha256 = "1sz5lbw0cvzspg19n45x8kx5xhs26hf2a726ls1byc6r5cg52hcw";

  # Fails with:
  # - Failed to write to log, can't make directories for new logfile: mkdir /var: permission denied
  doCheck = false;

  meta = with lib; {
    description = "Connect your devices into a single secure private WireGuard-based mesh network";
    homepage = "https://github.com/wiretrustee/wiretrustee";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
