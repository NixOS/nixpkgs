{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "packet-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "packethost";
    repo = pname;
    rev = version;
    sha256 = "sha256-P1Bn6vli0d/MroHUsioTWBrjWN+UZmSo3qmzo+fCDwM=";
  };

  vendorSha256 = "sha256-PjKiUdhN87guPAa0loZrWYuwbl0HaspuIjmKgyq4Zp8=";

  postInstall = ''
    ln -s $out/bin/packet-cli $out/bin/packet
  '';

  doCheck = false;

  meta = with lib; {
    description = "Official Packet CLI";
    homepage = "https://github.com/packethost/packet-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
