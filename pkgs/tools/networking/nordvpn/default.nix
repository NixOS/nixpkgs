{ stdenv, lib, fetchurl, openvpn, libxml2, autoPatchelfHook, dpkg }:

let
  version = "3.10.0-1";
in stdenv.mkDerivation {
  pname = "nordvpn";
  inherit version;

  src = fetchurl {
    url = "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn_${version}_amd64.deb";
    sha256 = "BNAInjJlQsYpxfUKI13oK/P6n6gpBlvgSQoJAuZ3C2M=";
  };

  nativeBuildInputs = [ libxml2 autoPatchelfHook dpkg ];

  unpackPhase = ''
    dpkg -x $src unpacked
  '';

  installPhase = ''
    mkdir -p $out/
    sed -i 's;ExecStart=.*;;g' unpacked/usr/lib/systemd/system/nordvpnd.service
    cp -r unpacked/* $out/
    mv $out/usr/* $out/
    mv $out/sbin/nordvpnd $out/bin/
    rm -r $out/sbin
    rm $out/var/lib/nordvpn/openvpn
    ln -s ${openvpn}/bin/openvpn $out/var/lib/nordvpn/openvpn
  '';

  meta = with lib; {
    description = "NordVPN: Best VPN service. Online security starts with a click";
    downloadPage = "https://nordvpn.com/download/";
    homepage = "https://nordvpn.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ juliosueiras ];
    platforms = platforms.linux;
  };
}
