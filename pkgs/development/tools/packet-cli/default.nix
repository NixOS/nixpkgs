{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "packet-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "packethost";
    repo = pname;
    rev = version;
    sha256 = "0dlcx186l8kh6w3i4dvj7v90lhjkgvq1xkjb2vijy6399z41grw2";
  };

  vendorSha256 = "1y1c369gsaf5crkdvv5g8d9p2g5602x2gcj8zy1q3wjx9lwhl0i6";

  postInstall = ''
    ln -s $out/bin/packet-cli $out/bin/packet
  '';

  doCheck = false;

  meta = with lib; {
    description = "Official Packet CLI";
    homepage = "https://github.com/packethost/packet-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne nshalman ];
  };
}
