{ lib
, buildGoModule
, fetchFromGitHub
, wiretrustee
, testVersion
}:

buildGoModule rec {
  pname = "wiretrustee";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "wiretrustee";
    repo = "wiretrustee";
    rev = "v${version}";
    sha256 = "0wyi8n29q8gsza6cwwp8qqri8wfp1rlfhizw4y65r0dq3xc7g1wm";
  };

  vendorSha256 = "13yfh3ylm9pyqjrhwdkl8hk5rr7d2bgi6n2xcy1aw1b674fk5713";

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
