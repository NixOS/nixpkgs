{ stdenv, lib, fetchurl, libxml2, autoPatchelfHook, dpkg }:

stdenv.mkDerivation rec {
  name = "nordvpn";
  version = "3.10.0-1";

  src = fetchurl {
    url = "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn_${version}_amd64.deb";
    sha256 = "BNAInjJlQsYpxfUKI13oK/P6n6gpBlvgSQoJAuZ3C2M=";
  };

  nativeBuildInputs = [ libxml2 autoPatchelfHook dpkg ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" "distPhase" ];

  unpackPhase = "dpkg -x $src unpacked";

  installPhase = ''
    mkdir -p $out/
    sed -i 's;ExecStart=.*;;g' unpacked/usr/lib/systemd/system/nordvpnd.service
    cp -r unpacked/* $out/
    mv $out/usr/* $out/
    cp $out/sbin/* $out/bin/
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
