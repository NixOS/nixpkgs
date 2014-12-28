{ stdenv, fetchgit, makeWrapper, openresolv, coreutils }:

stdenv.mkDerivation rec {
  name = "update-resolv-conf";

  src = fetchgit {
    url = https://github.com/masterkorp/openvpn-update-resolv-conf/;
    rev = "dd968419373bce71b22bbd26de962e89eb470670";
    sha256 = "dd0e3ea3661253d565bda876eb52a3f8461a3fc8237a81c40809c2071f83add1";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm555 update-resolv-conf.sh $out/libexec/openvpn/update-resolv-conf
    sed -i 's,^\(RESOLVCONF=\).*,\1resolvconf,' $out/libexec/openvpn/update-resolv-conf

    wrapProgram $out/libexec/openvpn/update-resolv-conf \
        --prefix PATH : ${coreutils}/bin:${openresolv}/sbin
  '';

  meta = with stdenv.lib; {
    description = "Script to update your /etc/resolv.conf with DNS settings that come from the received push dhcp-options";
    homepage = https://github.com/masterkorp/openvpn-update-resolv-conf/;
    maintainers = maintainers.abbradar;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
