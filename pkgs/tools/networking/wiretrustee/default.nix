{ lib
, buildGoModule
, fetchFromGitHub
, wiretrustee
, testVersion
}:

buildGoModule rec {
  pname = "wiretrustee";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "wiretrustee";
    repo = "wiretrustee";
    rev = "v${version}";
    sha256 = "sha256-3vBx1QNTgV67Yo0Wn6GKy3QWa9IIEW/9DaHuJ2BEN3M=";
  };

  vendorSha256 = "sha256-BLiunzoUr7FcwfGlwoWXaK1D9NKytinWrV2+bZd+YK8=";
  patches = [
    ./log-path.patch
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Fails with:
  # - Failed to write to log, can't make directories for new logfile: mkdir /var: permission denied
  doCheck = false;

  passthru.tests.version = testVersion { package = wiretrustee; command = "client version"; };

  meta = with lib; {
    description = "Connect your devices into a single secure private WireGuard-based mesh network";
    homepage = "https://github.com/wiretrustee/wiretrustee";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
