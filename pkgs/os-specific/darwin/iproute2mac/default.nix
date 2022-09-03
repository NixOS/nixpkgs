{ lib, stdenv, fetchFromGitHub, darwin, python3 }:

stdenv.mkDerivation rec {
  version = "1.4.0";
  pname = "iproute2mac";

  src = fetchFromGitHub {
    owner = "brona";
    repo = "iproute2mac";
    rev = "v${version}";
    sha256 = "sha256-xakCNjmZpdVY7MMxk38EZatrakgkEeDhvljhl+aMmGg=";
  };

  buildInputs = [ python3 ];

  postPatch = ''
    substituteInPlace src/ip.py \
      --replace /sbin/ifconfig ${darwin.network_cmds}/bin/ifconfig \
      --replace /sbin/route ${darwin.network_cmds}/bin/route \
      --replace /usr/sbin/netstat ${darwin.network_cmds}/bin/netstat \
      --replace /usr/sbin/ndp ${darwin.network_cmds}/bin/ndp \
      --replace /usr/sbin/arp ${darwin.network_cmds}/bin/arp \
      --replace /usr/sbin/networksetup ${darwin.network_cmds}/bin/networksetup
  '';
  installPhase = ''
    mkdir -p $out/bin
    install -D -m 755 src/ip.py $out/bin/ip
  '';

  meta = with lib; {
    homepage = "https://github.com/brona/iproute2mac";
    description = "CLI wrapper for basic network utilites on Mac OS X inspired with iproute2 on Linux systems - ip command.";
    license = licenses.mit;
    maintainers = with maintainers; [ jiegec ];
    platforms = platforms.darwin;
  };
}
