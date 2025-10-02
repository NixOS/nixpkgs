{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  openresolv,
  coreutils,
  systemd,
}:

let
  binPath = lib.makeBinPath [
    coreutils
    openresolv
    systemd
  ];

in
stdenv.mkDerivation {
  pname = "update-resolv-conf";
  version = "unstable-2017-06-21";

  src = fetchFromGitHub {
    owner = "masterkorp";
    repo = "openvpn-update-resolv-conf";
    rev = "43093c2f970bf84cd374e18ec05ac6d9cae444b8";
    sha256 = "1lf66bsgv2w6nzg1iqf25zpjf4ckcr45adkpgdq9gvhkfnvlp8av";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm555 update-resolv-conf.sh $out/libexec/openvpn/update-resolv-conf
    install -Dm555 update-systemd-network.sh $out/libexec/openvpn/update-systemd-network

    for i in $out/libexec/openvpn/*; do
      wrapProgram $i --prefix PATH : ${binPath}
    done
  '';

  meta = with lib; {
    description = "Script to update your /etc/resolv.conf with DNS settings that come from the received push dhcp-options";
    homepage = "https://github.com/masterkorp/openvpn-update-resolv-conf/";
    maintainers = [ ];
    license = licenses.gpl2Only;
    platforms = platforms.unix;
  };
}
