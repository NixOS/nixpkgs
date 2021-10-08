{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wiretrustee";
  version = "0.1.0-beta.3";

  src = fetchFromGitHub {
    owner = "wiretrustee";
    repo = "wiretrustee";
    rev = "v${version}";
    sha256 = "1i52zm660561mbhibwd3adgh8g4ql3m7hrgjndv23j2vn2vz12bp";
  };

  vendorSha256 = "014nkhy3kf2aq14k68h8fgcpvzn5bvd3jvsf26ix61nykc24laga";

  doCheck = false;

  meta = with lib; {
    description = "Connect your devices into a single secure private WireGuard-based mesh network";
    homepage = "https://github.com/wiretrustee/wiretrustee";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
