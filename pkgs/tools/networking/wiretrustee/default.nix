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
    # Fails with:
    # - Failed to write to log, can't make directories for new logfile: mkdir /var: permission denied
    ./log-path.patch
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  #doCheck = false;
  checkPhase = ''
    runHook preCheck

    # Failing tests:
    #
    # client/cmd:
    # up_test.go:80: expected wireguard interface wt0 to be created
    # "TestUp"
    # "TestUp_Start"
    #
    # client/internal:
    # === RUN   TestEngine_MultiplePeers
    # level=error msg="failed creating interface wt3: [CreateTUN(\"wt3\") failed; /dev/net/tun does not exist]"
    #
    # iface:
    # iface_test.go:186: CreateTUN("utun1003") failed; /dev/net/tun does not exist
    # TestUp

    for pkg in $(getGoDirs test | grep -Ev 'client\/cmd|client\/internal|iface'); do
      buildGoDir test $checkFlags "$pkg"
    done

    runHook postCheck
  '';
  passthru.tests.version = testVersion { package = wiretrustee; command = "client version"; };

  meta = with lib; {
    description = "Connect your devices into a single secure private WireGuard-based mesh network";
    homepage = "https://github.com/wiretrustee/wiretrustee";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
