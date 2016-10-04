{ stdenv, lib, fetchFromGitHub, makeWrapper, openresolv, coreutils, which, systemd }:

let
  binPath = lib.makeBinPath [ coreutils openresolv which systemd ];

in stdenv.mkDerivation rec {
  name = "update-resolv-conf-2016-04-24";

  src = fetchFromGitHub {
    owner = "masterkorp";
    repo = "openvpn-update-resolv-conf";
    rev = "994574f36b9147cc78674a5f13874d503a625c98";
    sha256 = "1rvzlaj53k8s09phg4clsyzlmf44dmwwyvg0nbg966sxp3xsqlxc";
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
