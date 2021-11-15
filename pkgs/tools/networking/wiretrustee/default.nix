{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wiretrustee";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "wiretrustee";
    repo = "wiretrustee";
    rev = "v${version}";
    sha256 = "11crspy55kgsqnh64xa4dbmagyiy871q7klzassgpiqlcpbsfz88";
  };

  vendorSha256 = "13yfh3ylm9pyqjrhwdkl8hk5rr7d2bgi6n2xcy1aw1b674fk5713";

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
