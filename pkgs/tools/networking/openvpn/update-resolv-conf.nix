{ stdenv, lib, fetchFromGitHub, makeWrapper, openresolv, coreutils, systemd }:

let
  binPath = lib.makeBinPath [ coreutils openresolv systemd ];

in stdenv.mkDerivation rec {
  name = "update-resolv-conf-2016-09-30";

  src = fetchFromGitHub {
    owner = "masterkorp";
    repo = "openvpn-update-resolv-conf";
    rev = "09cb5ab5a50dfd6e77e852749d80bef52d7a6b34";
    sha256 = "0s5cilph0p0wiixj7nlc7f3hqmr1mhvbfyapd0060n3y6xgps9y9";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm555 update-resolv-conf.sh $out/libexec/openvpn/update-resolv-conf
    install -Dm555 update-systemd-network.sh $out/libexec/openvpn/update-systemd-network

    for i in $out/libexec/openvpn/*; do
      wrapProgram $i --prefix PATH : ${binPath}
    done
  '';

  meta = with stdenv.lib; {
    description = "Script to update your /etc/resolv.conf with DNS settings that come from the received push dhcp-options";
    homepage = "https://github.com/masterkorp/openvpn-update-resolv-conf/";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
